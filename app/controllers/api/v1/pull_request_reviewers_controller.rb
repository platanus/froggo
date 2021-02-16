class Api::V1::PullRequestReviewersController < Api::V1::BaseController
  before_action :authenticate_github_user
  # POST /pull_request_reviewer/add
  def add_reviewer
    request_reviewer(
      pull_request.repository.full_name,
      pull_request.gh_number,
      [permitted_params[:reviewer]]
    )
  end

  private

  def request_reviewer(repository, gh_number, reviewer)
    client.request_pull_request_review(
      repository,
      gh_number,
      reviewer
    )
  end

  def pull_request
    @pull_request ||= PullRequest.find(permitted_params[:pull_request_id])
  end

  def permitted_params
    params.require(:pull_request_reviewer).permit(:pull_request_id, :reviewer)
  end

  def token
    @token ||= github_session.token
  end

  def client
    @client ||= BuildOctokitClient.for(token: token)
  end
end
