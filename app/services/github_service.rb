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
        pull_request ||= PullRequest.create!(gh_id: pr.id, repository_id: repo_id, pr_state: pr.state)
        # If the pull requests exists and it hasn't been updated, continue with next pr
        if pull_request.gh_updated_at.nil? || (pull_request.gh_updated_at < pr.updated_at)
          pull_request.update!(
            title: pr.title,
            gh_number: pr.number,
            pr_state: pr.state,
            html_url: pr.html_url,
            gh_created_at: pr.created_at,
            gh_updated_at: pr.updated_at,
            gh_closed_at: pr.closed_at,
            gh_merged_at: pr.merged_at,
          )
        end
      end
    end
  end
end
