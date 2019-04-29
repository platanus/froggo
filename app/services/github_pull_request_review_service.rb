class GithubPullRequestReviewService < PowerTypes::Service.new(:token)
  DEFAULT_TEAM_ID = 2881208 ## froggo ID

  def import_all_from_repository(repository)
    repository.pull_requests.each do |pull_request|
      break unless repository.tracked

      ImportPullRequestReviewsJob.perform_later(pull_request, @token)
    end
  end

  def import_all_from_pull_request(pull_request)
    github_pull_request_reviews(pull_request).each do |github_pull_request_review|
      break unless pull_request.repository.tracked

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
    return unless pull_request.repository.reload.tracked

    params = build_pull_request_review_params(pull_request, github_pr_review)

    if pr_review = PullRequestReview.find_by(gh_id: github_pr_review.id)
      pr_review.update! params
    else
      pull_request.pull_request_reviews.create!(params)
    end
  end

  def delete_prs_reviews(pr_ids)
    PullRequestReview.where(pull_request_id: pr_ids).destroy_all
  end

  private

  def github_pull_request_reviews(pull_request)
    repository = pull_request.repository

    client.pull_request_reviews(repository.full_name, pull_request.gh_number,
      accept: 'application/vnd.github.thor-preview+json')
  end

  def build_pull_request_review_params(pull_request, github_pr_review)
    user = GithubUserService.new.find_or_create(github_pr_review.user)

    base_params = get_params(github_pr_review)
    users_params = {
      github_user_id: user.id,
      recommendation_behaviour: get_behaviour(pull_request, github_pr_review)
    }

    base_params.merge(users_params)
  end

  def get_params(github_pull_request_review)
    {
      gh_id: github_pull_request_review.id
    }
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end

  def get_behaviour(pull_request, gh_pull_request_review)
    reviewer = GithubUser.find_by(gh_id: gh_pull_request_review.user.id)
    pull_request.pull_request_review_requests.each do |request|
      if request.github_user_id === reviewer.id
        recommendations = team_review_request_recommendations(pull_request.owner_id)
        best_recommendations_ids = recommendations[:best].map { |user| user[:gh_id] }
        worst_recommendations_ids = recommendations[:worst].map { |user| user[:gh_id] }
        if best_recommendations_ids.include?(gh_pull_request_review.user.id)
          return :obedient
        elsif worst_recommendations_ids.include?(gh_pull_request_review.user.id)
          return :rebel
        end

        return :indifferent
      end
    end
    :not_defined
  end

  def team_review_request_recommendations(owner_id)
    GetReviewRecommendations.for(
      user_id: owner_id,
      other_users_id: other_team_members_id(owner_id)
    )
  end

  def other_team_members_id(owner_id)
    team_members_gh_ids =
      github_session
      .get_team_members(DEFAULT_TEAM_ID)
      &.pluck(:id)
    GithubUser
      .where(gh_id: team_members_gh_ids)
      .pluck(:id)
      .reject { |id| id == owner_id }
  end
end
