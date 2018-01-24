class GithubPullRequestService < PowerTypes::Service.new(:token)
  def import_all_from_repository(repository)
    github_pull_requests(repository).each do |github_pull_request|
      import_github_pull_request(repository, github_pull_request)
    end
  end

  def handle_webhook_event(data)
    # Receive a pull request event (CRUD) and process it.
  end

  private

  def github_pull_requests(repository)
    client.pull_requests(repository.full_name, state: 'all')
  end

  def import_github_pull_request(repository, github_pull_request)
    owner = GithubUserService.new.find_or_create(github_pull_request.user)
    pull_request_params = get_pull_request_params(github_pull_request).merge(owner_id: owner.id)

    repository.pull_requests
              .create_with(pull_request_params)
              .find_or_create_by!(gh_id: github_pull_request.id)
  end

  def get_pull_request_params(github_pull_request)
    {
      pr_state: github_pull_request.state,
      title: github_pull_request.title,
      gh_number: github_pull_request.number,
      html_url: github_pull_request.html_url,
      gh_created_at: github_pull_request.created_at,
      gh_updated_at: github_pull_request.updated_at,
      gh_closed_at: github_pull_request.closed_at,
      gh_merged_at: github_pull_request.merged_at
    }
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end
end
