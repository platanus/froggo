class GithubPullRequestReviewService < PowerTypes::Service.new(:token)
  def import_all_from_repository(repository)
    # Obtain list of reviews for each PR of the repository and pull request
    # and persist them in DB.
  end

  def import_all_from_pull_request(pull_request)
    github_pull_request_reviews(pull_request).each do |github_pull_request_review|
      import_github_pull_request_review(pull_request, github_pull_request_review)
    end
  end

  def handle_webhook_event(data)
    # Receive review event and process it.
  end

  private

  def github_pull_request_reviews(pull_request)
    repository = pull_request.repository

    client.pull_request_reviews(repository.full_name, pull_request.gh_number,
      accept: 'application/vnd.github.thor-preview+json')
  end

  def import_github_pull_request_review(pull_request, github_pull_request_review)
    user = GithubUserService.new.find_or_create(github_pull_request_review.user)

    pull_request_review_params = get_pull_request_review_params(github_pull_request_review)
                                 .merge(github_user_id: user.id)

    pull_request.pull_request_reviews
                .create_with(pull_request_review_params)
                .find_or_create_by!(gh_id: github_pull_request_review.id)
  end

  def get_pull_request_review_params(github_pull_request_review)
    {
      gh_id: github_pull_request_review.id
    }
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end
end
