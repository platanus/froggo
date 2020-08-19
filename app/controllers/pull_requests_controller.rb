class PullRequestsController < ApplicationController
  def index
    @pull_requests = PullRequest.by_organizations([organization.id]).limit(20)
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
