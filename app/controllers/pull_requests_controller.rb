class PullRequestsController < ApplicationController
  before_action :authenticate_github_user

  def index
    @likes_given = Like.where(github_user_id: github_user.id, likeable_type: "PullRequest")
    @organization_name = organization_name
    @pull_requests = PullRequest.by_organizations(
      [organization.id]
    )
    @pull_requests = FilterPullRequests.for(all_pull_requests: @pull_requests,
                                            options: filtering_params)
    @pull_requests = @pull_requests.order(created_at: :desc)
    @pull_requests = @pull_requests.page(params[:page]) unless params.has_key? :top_liked
    @serialized_pull_requests = ActiveModel::Serializer::CollectionSerializer.new(
      @pull_requests, serializer: Api::V1::PullRequestSerializer
    )
  end

  def show
    @pull_request = PullRequest.find(params[:id])
    @serialized_pull_request = Api::V1::PullRequestSerializer.new(@pull_request)
    @liked = Like.where(github_user_id: github_user.id,
                        likeable_type: "PullRequest",
                        likeable_id: @pull_request.id)[0]
    @reviewers = PullRequestReview.where(pull_request_id: @pull_request.id)
    @serialized_reviewers = ActiveModel::Serializer::CollectionSerializer.new(
      @reviewers, serializer:  Api::V1::PullRequestReviewSerializer
    )
  end

  private

  def organization
    @organization ||= Organization.find_by(login: organization_name)
  end

  def organization_name
    params.require(:organization_name)
  end

  def filtering_params
    params.permit(:project_name, :owner_name, :start_date, :title, :end_date, :top_liked)
  end
end
