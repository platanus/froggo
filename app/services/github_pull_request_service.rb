class GithubPullRequestService < PowerTypes::Service.new(:token)
  def import_all_from_repository(repository)
    github_pull_requests(repository).each do |github_pull_request|
      import_github_pull_request(repository, github_pull_request)
    end
  end

  def handle_webhook_event(data)
    data_object = data.is_a?(Hash) ? RecursiveOpenStruct.new(data) : data
    repo = Repository.find_by(gh_id: data_object.repository.id)

    import_github_pull_request(repo, data_object.pull_request)
  end

  def import_github_pull_request(repository, github_pull_request)
    return unless repository.reload.tracked
    params = build_pull_request_params(github_pull_request)

    if pull_request = PullRequest.find_by(gh_id: github_pull_request.id)
      pull_request.update! params
    else
      repository.pull_requests.create!(params)
    end
  end

  private

  def github_pull_requests(repository)
    client.pull_requests(repository.full_name, state: 'all')
  end

  def build_pull_request_params(github_pull_request)
    owner = GithubUserService.new.find_or_create(github_pull_request.user)

    base_params = get_base_params(github_pull_request)
    users_params = { owner_id: owner.id }

    if github_pull_request.respond_to?(:merged_at) && !github_pull_request.merged_at.nil?
      user = get_merger_user(github_pull_request)
      merged_by = GithubUserService.new.find_or_create(user)
      users_params[:merged_by_id] = merged_by.id
    end

    base_params.merge(users_params)
  end

  def get_merger_user(github_pull_request)
    if github_pull_request.respond_to?(:merged_by)
      return github_pull_request.merged_by
    end
    get_user_from_request(github_pull_request)
  end

  def get_user_from_request(github_pull_request)
    repo_full_name = github_pull_request.head.repo.full_name
    pr_number = github_pull_request.number
    pr_response = client.pull_request(repo_full_name, pr_number)
    if pr_response.respond_to?(:merged_by)
      return pr_response.merged_by
    end
  end

  def get_base_params(github_pull_request)
    {
      gh_id: github_pull_request.id,
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
