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
    if response
      unless PullRequestReviewRequest.find_by(
        github_user_id: requested_reviewer.id,
        pull_request_id: pull_request.id
      )
        pull_request.pull_request_review_requests.create!(get_request_base_params)
      end
      requested_reviewer
    end
  end

  def get_request_base_params
    {
      gh_id: pull_request.gh_number,
      github_user_id: requested_reviewer.id
    }
  end

  def requested_reviewer
    @requested_reviewer ||= GithubUser.where(login: permitted_params[:reviewer]).first
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
