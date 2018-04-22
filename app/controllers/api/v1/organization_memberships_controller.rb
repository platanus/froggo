class Api::V1::OrganizationMembershipsController < Api::V1::BaseController
  before_action :authenticate_github_user
  before_action :ensure_organization_admin

  def update
    membership.update! tracked: params[:tracked]
    respond_with membership, status: 202
  end

  private

  def membership
    @membership ||= OrganizationMembership.find(params[:id])
  end

  def github_organization
    github_session.organizations.find { |org| org[:id] == membership.organization[:gh_id] }
  end

  def ensure_organization_admin
    respond_api_error(401, "not_authorized", nil) unless github_organization[:role] == "admin"
  end
end
