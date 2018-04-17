class Api::V1::OrganizationsController < Api::V1::BaseController
  before_action :authenticate_github_user
  before_action :ensure_organization_admin

  def sync
    OrganizationSyncJob.perform_later(
      OrganizationSync.find_or_create_by(organization: organization),
      @github_session.token
    )
    redirect_to settings_organization_path(name: organization.login)
  end

  private

  def organization
    @organization ||= Organization.find(params[:id])
  end

  def github_organization
    github_session.organizations.find { |org| org[:id] == organization[:gh_id] }
  end

  def ensure_organization_admin
    respond_api_error(401, "not_authorized", nil) unless github_organization[:role] == "admin"
  end
end
