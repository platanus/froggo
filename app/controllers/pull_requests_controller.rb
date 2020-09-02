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

  private

  def organization
    @organization ||= Organization.find_by(login: organization_name)
  end

  def organization_name
    params.require(:organization_name)
  end
end
