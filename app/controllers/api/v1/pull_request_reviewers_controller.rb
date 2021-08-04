class Api::V1::PullRequestReviewersController < Api::V1::BaseController
  before_action :authenticate_github_user
  # POST /pull_request_reviewer/add
  def add_reviewer
    respond_with request_reviewer(
      pull_request.repository.full_name,
      pull_request.gh_number,
      { reviewers: [permitted_params[:reviewer]] }
    )
  end

  private

  def request_reviewer(repository, gh_number, reviewer)
    response = client.request_pull_request_review(
      repository,
      gh_number,
      reviewer
    )
    return unless response

    PullRequestReviewRequest.create_with(gh_id: pull_request.gh_number).find_or_create_by!(
      github_user_id: requested_reviewer.id,
      pull_request_id: pull_request.id
    )

    AssignationMetric.create_with(from: permitted_params[:from]).find_or_create_by!(
      github_user_id: requested_reviewer.id,
      pull_request_id: pull_request.id
    )

    requested_reviewer
  end

  def requested_reviewer
    @requested_reviewer ||= GithubUser.where(login: permitted_params[:reviewer]).first
  end

  def pull_request
    @pull_request ||= PullRequest.find(permitted_params[:pull_request_id])
  end

  def permitted_params
    params.require(:pull_request_reviewer)
          .permit(:pull_request_id, :reviewer, :from)
          .with_defaults(from: :desktop)
  end

  def token
    @token ||= github_session.token
  end

  def client
    @client ||= BuildOctokitClient.for(token: token)
  end
end
