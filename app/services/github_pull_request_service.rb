class GithubPullRequestService < PowerTypes::Service.new(:token)
  def import_all_from_repository(repository)
    github_pull_requests(repository).each do |github_pull_request|
      import_github_pull_request(repository, github_pull_request)
    end
  end

  def handle_webhook_event(data)
    data = OpenStruct.new(data) if data.is_a? Hash
    repo = Repository.find_by(gh_id: data.repository.id)

    import_github_pull_request(repo, data.pull_request)
  end

  def import_github_pull_request(repository, github_pull_request)
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

    merged = github_pull_request.respond_to?(:merged_at)
    create_merger_user(github_pull_request, users_params) if merged

    base_params.merge(users_params)
  end

  def create_merger_user(github_pull_request, users_params)
    if github_pull_request.respond_to?(:merged_by)
      create_user_from_response(github_pull_request.merged_by, users_params)
    elsif !github_pull_request.merged_at.nil?
      create_user_from_request(github_pull_request, users_params)
    end
  end

  def create_user_from_response(user, users_params)
    merged_by = GithubUserService.new.find_or_create(user)
    users_params[:merged_by_id] = merged_by.id
  end

  def create_user_from_request(github_pull_request, users_params)
    repo_full_name = github_pull_request.head.repo.full_name
    pr_number = github_pull_request.number
    pr_response = client.pull_request(repo_full_name, pr_number)
    if pr_response.respond_to?(:merged_by)
      create_user_from_response(pr_response.merged_by, users_params)
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
