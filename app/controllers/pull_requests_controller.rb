class PullRequestsController < ApplicationController
  before_action :authenticate_github_user

  def index
    github_user
    @likes_given = Like.where(github_user_id: github_user.id, likeable_type: "PullRequest")
    @pull_requests = PullRequest.by_organizations(
      [organization.id]
    ).order(created_at: :desc).limit(100)
    @serialized_pull_requests = ActiveModel::Serializer::CollectionSerializer.new(
      @pull_requests, each_serializer: PullRequestSerializer
    )
  end

  def show
    github_user
    @pull_request = PullRequest.find(params[:id])
    @likes_given = Like.where(github_user_id: github_user.id, likeable_type: "PullRequest")
    @liked = @likes_given.where(likeable_id: @pull_request.id)[0]
    @reviewers_id = PullRequestReviewRequest.where(pull_request_id: @pull_request.id)
    position_reviewer = 0
    @reviewers = []
    loop do
      if position_reviewer == @reviewers_id.length
        break
      end

      @reviewers.push(GithubUser.where(id: @reviewers_id[position_reviewer].github_user_id)[0])
      position_reviewer += 1
    end
  end

  private

  def organization
    @organization ||= Organization.find_by(login: organization_name)
  end

  def organization_name
    params.require(:organization_name)
  end
end
