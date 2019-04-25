class GithubPullRequestService < PowerTypes::Service.new(:token)
  GITHUB_PER_PAGE = 20

  def import_all_from_repository(repository)
    total_pages = total_prs_pages(repository)
    (1..total_pages).each do |page|
      ImportPullRequestsJob.perform_later(repository, page, @token)
    end
  end

  def handle_webhook_event(data)
    data_object = data.is_a?(Hash) ? RecursiveOpenStruct.new(data) : data
    repo = Repository.find_by(gh_id: data_object.repository.id)

    pull_request = import_github_pull_request(repo, data_object.pull_request)
    if data_object.action === "review_requested"
      add_requested_reviewers_to_pull_request(
        pull_request,
        data_object.pull_request,
        data_object.requested_reviewer
      )
    end
  end

  def import_page_from_repository(repository, page)
    github_pull_requests(repository, page: page).each do |github_pull_request|
      break unless repository.tracked

      pull_request = import_github_pull_request(repository, github_pull_request)
      ImportPullRequestReviewsJob.perform_later(pull_request, @token)
    end
  end

  def import_github_pull_request(repository, github_pull_request)
    return unless repository.reload.tracked

    params = build_pull_request_params(repository, github_pull_request)

    if pull_request = PullRequest.find_by(gh_id: github_pull_request.id)
      pull_request.update! params
    else
      pull_request = repository.pull_requests.create!(params)
    end
    pull_request
  end

  def delete_prs(pr_ids)
    PullRequest.where(id: pr_ids).destroy_all
  end

  def add_requested_reviewers_to_pull_request(pull_request, gh_pull_request, requested_reviewer)
    unless PullRequestReviewRequest.find_by(
      github_user_id: requested_reviewer.id,
      pull_request_id: pull_request.id
    )
      base_params = get_request_base_params(gh_pull_request, requested_reviewer.id)
      pull_request.pull_request_review_requests.create!(base_params)
    end
  end

  private

  def github_pull_requests(repository, page: nil)
    client.pull_requests(repository.full_name, state: 'all', page: page)
  end

  def build_pull_request_params(repository, github_pull_request)
    owner = GithubUserService.new.find_or_create(github_pull_request.user)

    base_params = get_base_params(github_pull_request)
    users_params = { owner_id: owner.id }

    if github_pull_request.respond_to?(:merged_at) && !github_pull_request.merged_at.nil?
      user = get_merger_user(repository, github_pull_request)
      merged_by = GithubUserService.new.find_or_create(user)
      users_params[:merged_by_id] = merged_by.id
    end

    base_params.merge(users_params)
  end

  def get_merger_user(repository, github_pull_request)
    if github_pull_request.respond_to?(:merged_by)
      return github_pull_request.merged_by
    end

    get_user_from_request(repository, github_pull_request)
  end

  def get_user_from_request(repository, github_pull_request)
    repo_full_name = repository.full_name
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
    @client ||= BuildOctokitClient.for(token: @token, per_page: GITHUB_PER_PAGE)
  end

  def total_prs_pages(repo)
    github_pull_requests(repo)
    if client.last_response.rels.present?
      CGI.parse(URI.parse(client.last_response.rels[:last].href).query)
         .symbolize_keys[:page].first.to_i
    else
      1
    end
  end

  def get_request_base_params(github_pull_request, reviewer_id)
    {
      gh_id: github_pull_request.id,
      github_user_id: reviewer_id
    }
  end
end
