class GithubPullRequestReviewService < PowerTypes::Service.new(:token)
  def import_all_from_repository(repository)
    repository.pull_requests.each do |pull_request|
      import_all_from_pull_request(pull_request)
    end
  end

  def import_all_from_pull_request(pull_request)
    github_pull_request_reviews(pull_request).each do |github_pull_request_review|
      import_github_pull_request_review(pull_request, github_pull_request_review)
    end
  end

  def handle_webhook_event(data)
    data_object = data.is_a?(Hash) ? RecursiveOpenStruct.new(data) : data
    if data_object.action == 'submitted'
      pull_req = PullRequest.find_by(gh_id: data_object.pull_request.id)
      import_github_pull_request_review(pull_req, data_object.review)
    end
  end

  def import_github_pull_request_review(pull_request, github_pr_review)
    params = build_pull_request_review_params(github_pr_review)

    if pr_review = PullRequestReview.find_by(gh_id: github_pr_review.id)
      pr_review.update! params
    else
      pull_request.pull_request_reviews.create!(params)
    end
  end

  private

  def github_pull_request_reviews(pull_request)
    repository = pull_request.repository

    client.pull_request_reviews(repository.full_name, pull_request.gh_number,
      accept: 'application/vnd.github.thor-preview+json')
  end

  def build_pull_request_review_params(github_pr_review)
    user = GithubUserService.new.find_or_create(github_pr_review.user)

    base_params = get_base_params(github_pr_review)
    users_params = { github_user_id: user.id }

    base_params.merge(users_params)
  end

  def get_base_params(github_pull_request_review)
    {
      gh_id: github_pull_request_review.id
    }
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end
end
