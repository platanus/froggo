class GithubPullRequestReviewService < PowerTypes::Service.new(:token)
  def import_all_from_repository(repository)
    repository.pull_requests.each do |pull_request|
      break unless repository.tracked

      ImportPullRequestReviewsJob.perform_later(pull_request, @token)
    end
  end

  def import_all_from_pull_request(pull_request)
    organization_id = 0
    include_recommendation = false
    github_pull_request_reviews(pull_request).each do |github_pull_request_review|
      break unless pull_request.repository.tracked

      import_github_pull_request_review(pull_request,
        github_pull_request_review,
        organization_id,
        include_recommendation)
    end
  end

  def handle_webhook_event(data)
    data_object = data.is_a?(Hash) ? RecursiveOpenStruct.new(data) : data
    if data_object.action == 'submitted'
      pull_req = PullRequest.find_by(gh_id: data_object.pull_request.id)
      repo = Repository.find_by(gh_id: data_object.repository.id)
      organization = Organization.find(repo.organization_id)
      organization_id = organization.id
      include_recommendation = true
      import_github_pull_request_review(pull_req,
        data_object.review,
        organization_id,
        include_recommendation)
    end
  end

  def import_github_pull_request_review(pull_request,
    github_pr_review,
    organization_id,
    include_recommendation)
    return unless pull_request.repository.reload.tracked

    params = build_pull_request_review_params(pull_request,
      github_pr_review,
      organization_id,
      include_recommendation)

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

  def build_pull_request_review_params(pull_request,
    github_pr_review,
    organization_id,
    include_recommendation)
    user = GithubUserService.new.find_or_create(github_pr_review.user)

    review_params = get_params(github_pr_review).merge(
      github_user_id: user.id
    )

    if include_recommendation
      review_params[:recommendation_behaviour] = get_behaviour(pull_request,
        github_pr_review,
        organization_id)
    end

    review_params
  end

  def get_params(github_pull_request_review)
    {
      gh_id: github_pull_request_review.id
    }
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end

  def get_behaviour(pull_request, gh_pull_request_review, org_id)
    reviewer = GithubUser.find_by(gh_id: gh_pull_request_review.user.id)
    pull_request.pull_request_review_requests.each do |request|
      if request.github_user_id === reviewer.id
        recommendations = team_review_request_recommendations(pull_request.owner_id, org_id)
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

  def team_review_request_recommendations(owner_id, organization_id)
    GetReviewRecommendations.for(
      github_user_id: owner_id,
      other_users_ids: other_team_members_id(owner_id, organization_id)
    )
  end

  def other_team_members_id(owner_id, organization_id)
    OrganizationMembership.where(organization_id: organization_id,
                                 is_member_of_default_team: true)
                          .map do |membership|
      {
        user_id: membership.github_user_id
      }.reject { |user_id| user_id == owner_id }
    end
  end
end
