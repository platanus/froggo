class GithubService < PowerTypes::Service.new(:user)
  def create_organizations
    if orgs = OctokitClient.fetch_organizations(@user.token)
      orgs.each do |o|
        organization = Organization.create_with(
          login: o[:login],
          name: o[:name]
        ).find_or_create_by(gh_id: o[:id])
        organization.update! description: o[:description],
                             tracked: false,
                             html_url: "https://github.com/#{o[:login]}/",
                             owner_id: @user.id,
                             avatar_url: o[:avatar_url]
      end
    end
  end

  def create_organization_repositories(organization)
    if repos = OctokitClient.fetch_organization_repositories(organization.login, @user.token)
      repos.each do |r|
        repository = Repository.create_with(
          gh_id: r[:gh_id],
          full_name: r[:full_name],
          organization: organization
        ).find_or_create_by! gh_id: r[:id]
        repository.update! name: r[:name],
                           full_name: r[:full_name],
                           url: r[:url],
                           html_url: r[:html_url]
      end
    end
  end

  def create_repository_pull_requests(repo_id, repo_full_name)
    if pull_requests = OctokitClient.fetch_repository_pull_requests(repo_full_name, @user.token)
      pull_requests.each do |pr|
        pull_request = PullRequest.find_by(gh_id: pr.id)
        pull_request ||= PullRequest.create!(gh_id: pr.id,
                                             repository_id: repo_id,
                                             pr_state: pr.state)
        # If the pull requests exists and it hasn't been updated, continue with next pr
        if pull_request.gh_updated_at.nil? || (pull_request.gh_updated_at < pr.updated_at)
          update_pull_request(pull_request, pr)
          update_pull_request_asignees(pull_request, pr) if pr.assignees
          update_pull_req_reviewers(pull_request)
        end
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

  def update_pull_request_asignees(old_pr, new_pr)
    if !new_pr.assignees || new_pr.assignees.empty?
      unless old_pr.pull_request_relations.assignees.empty?
        old_pr.pull_request_relations.assignees.destroy_all
      end
    else
      new_assignees = new_pr.assignees.reduce(Hash.new) do |result, assignee|
        result.merge(assignee.login => assignee)
      end
      pr_assignees = old_pr.pull_request_relations.assignees
                           .joins(:github_user).pluck(:login).to_set
      # Remove existing relations
      new_assignees.delete_if { |login, _| pr_assignees.include? login }
      add_new_relations(old_pr, new_assignees, :assignee)
    end
  end

  def update_pull_req_reviewers(old_pr)
    reviews = OctokitClient.fetch_pull_request_reviews(old_pr.repository.full_name,
      old_pr.gh_number, @user.token)
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

  def add_new_relations(pull_req, new_assignees, relation_type)
    github_users = GithubUser.where(login: new_assignees.keys)
    github_users.each do |user|
      pull_req.pull_request_relations.create!(pr_relation_type: relation_type, github_user: user)
    end
    github_users_login = github_users.pluck(:login).to_set
    new_assignees.delete_if { |login, _| github_users_login.include? login }
    new_assignees.each do |_, new_assignee|
      user = create_github_user(new_assignee)
      pull_req.pull_request_relations.create!(
        pr_relation_type: relation_type,
        github_user: user
      )
    end
  end

  def create_github_user(user_data)
    GithubUser.create(
      gh_id: user_data.id,
      login: user_data.login,
      avatar_url: user_data.avatar_url,
      html_url: user_data.html_url,
      tracked: true
    )
  end
end
