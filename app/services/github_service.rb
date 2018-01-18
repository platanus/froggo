class GithubService < PowerTypes::Service.new(:user_token, user_id: nil)
  def user
    client.user
  end

  def create_organizations
    client.orgs.each do |o|
      organization = Organization.create_with(
        login: o[:login],
        name: o[:name]
      ).find_or_create_by(gh_id: o[:id])
      organization.update! description: o[:description],
                           tracked: false,
                           html_url: "https://github.com/#{o[:login]}/",
                           owner_id: @user_id,
                           avatar_url: o[:avatar_url]
    end
  end

  def organization_memberships
    client.organization_memberships.map do |mem|
      {
        id: mem.organization.id,
        login: mem.organization.login,
        role: mem.role
      }
    end
  rescue Octokit::Unauthorized => ex
    puts ex.message
  end

  def create_organization_repositories(organization)
    client.org_repos(organization.login).each do |r|
      repository = Repository.create_with(
        gh_id: r[:gh_id],
        full_name: r[:full_name],
        organization: organization
      ).find_or_create_by!(gh_id: r[:id])
      repository.update! name: r[:name],
                         full_name: r[:full_name],
                         url: r[:url],
                         html_url: r[:html_url]
    end
  end

  def create_repository_pull_requests(repo_id, repo_full_name)
    client.pull_requests(repo_full_name, state: 'all').each do |pr|
      pull_request = PullRequest.find_by(gh_id: pr.id)
      pull_request ||= PullRequest.create!(gh_id: pr.id,
                                           repository_id: repo_id,
                                           owner: get_github_user(pr.user),
                                           pr_state: pr.state)
      # If the pull requests exists and it hasn't been updated, continue with next pr
      if pull_request.gh_updated_at.nil? || (pull_request.gh_updated_at < pr.updated_at)
        update_pull_request_merge_by(pull_request, pr)
        update_pull_request(pull_request, pr)
        update_pull_req_reviewers(pull_request)
      end
    end
  end

  def update_pull_request(old_pr, new_pr)
    old_pr.update!(
      title: new_pr.title,
      gh_number: new_pr.number,
      pr_state: new_pr.state,
      html_url: new_pr.html_url,
      gh_created_at: new_pr.created_at,
      gh_updated_at: new_pr.updated_at,
      gh_closed_at: new_pr.closed_at,
      gh_merged_at: new_pr.merged_at
    )
  end

  def update_pull_request_merge_by(old_pr, new_pr)
    if old_pr.gh_merged_at.nil? && !new_pr.merged_at.nil?
      merge_commit = client.commit(old_pr.repository.full_name, new_pr.merge_commit_sha)
      old_pr.pull_request_relations.create!(
        pr_relation_type: :merge_by,
        github_user: get_github_user(merge_commit.author)
      )
    end
  end

  def update_pull_req_reviewers(old_pr)
    reviews = client.pull_request_reviews(old_pr.repository.full_name,
      old_pr.gh_number, accept: 'application/vnd.github.thor-preview+json')
    if reviews.empty?
      destroy_empty_reviews(old_pr)
    else
      new_reviewers = reviews.reduce(Hash.new) do |result, review|
        result.merge(review.user.login => review.user)
      end
      pr_reviewers = old_pr.pull_request_relations.reviewers
                           .joins(:github_user).pluck(:login).to_set
      # Remove existing relations
      new_reviewers.delete_if { |login, _| pr_reviewers.include? login }
      add_new_relations(old_pr, new_reviewers, :reviewer)
    end
  end

  def destroy_empty_reviews(old_pr)
    unless old_pr.pull_request_relations.reviewers.empty?
      old_pr.pull_request_relations.reviewers.destroy_all
    end
  end

  def add_new_relations(pull_req, users, relation_type)
    github_users = GithubUser.where(login: users.keys)
    # Create missing github_users
    github_users_login = github_users.pluck(:login).to_set
    users.delete_if { |login, _| github_users_login.include? login }
    github_users = github_users.to_a
    github_users += users.map { |_, user| get_github_user(user) }
    # Add the relation for all of them
    github_users.each do |user|
      pull_req.pull_request_relations.create!(pr_relation_type: relation_type, github_user: user)
    end
  end

  def get_github_user(user_data)
    GithubUser.create_with(
      login: user_data.login,
      avatar_url: user_data.avatar_url,
      html_url: user_data.html_url,
      tracked: true
    ).find_or_create_by!(gh_id: user_data.id)
  end

  def client
    @client ||= begin
      c = Octokit::Client.new(access_token: @user_token)
      c.auto_paginate = true
      c
    end
  end
end
