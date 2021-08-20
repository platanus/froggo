class Api::V1::PullRequestReviewersController < Api::V1::BaseController
  before_action :authenticate_github_user
  # POST /pull_request_reviewer/add
  def add_reviewer
    respond_with request_reviewer(
      pull_request.repository.full_name,
      pull_request.gh_number,
      permitted_params[:reviewer]
    )
  end

  private

  def request_reviewer(repository, gh_number, reviewers)
    response = client.request_pull_request_review(
      repository,
      gh_number,
      reviewers: reviewers
    )

    return unless response

    response.requested_reviewers.each do |reviewer|
      create_pull_request_reviewer(reviewer)
    end

    AssignationMetric.create!(
      from: permitted_params[:from],
      github_user_id: pull_request.owner.id,
      pull_request_id: pull_request.id
    )

    reviewers_as_github_users
  end

  def create_pull_request_reviewer(login)
    PullRequestReviewRequest.create_with(gh_id: pull_request.gh_number).find_or_create_by!(
      github_user_id: GithubUser.where(login: login).first.id,
      pull_request_id: pull_request.id
    )
  end

  def reviewers_as_github_users
    pull_request.pull_request_review_requests.map do |u|
      GithubUser.find(u.github_user_id)
    end
  end

  def pull_request
    @pull_request ||= PullRequest.find(permitted_params[:pull_request_id])
  end

  def permitted_params
    params.require(:pull_request_reviewer)
          .permit(:pull_request_id, { reviewer: [] }, :from)
          .with_defaults(from: :desktop)
  end

  def token
    @token ||= github_session.token
  end

  def client
    @client ||= BuildOctokitClient.for(token: token)
  end
end
