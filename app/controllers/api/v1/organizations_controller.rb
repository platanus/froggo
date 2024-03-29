class Api::V1::OrganizationsController < Api::V1::BaseController
  before_action :authenticate_github_user
  before_action :ensure_organization_admin, except: [:index, :create_all]
  after_action :update_organization_default_team_memberships, only: [:update]

  def index
    respond_with github_user.organizations
  end

  def create_all
    create_all_params[:selected_organizations].each do |organization|
      CreateOrganization.for(
        token: @github_session.token, github_organization: organization
      )
    end
    respond_with github_user.organizations, status: 202
  end

  def sync
    Github::OrganizationWebhookService.new(
      token: @github_session.token,
      organization: organization
    ).set
    OrganizationSyncJob.perform_later(
      OrganizationSync.find_or_create_by(organization: organization),
      @github_session.token
    )

    respond_with organization, status: 202
  end

  def check_sync
    respond_with OrganizationSync.find_by(organization_id: params[:id])
  end

  def update
    respond_with organization.update! update_params
  end

  private

  def organization
    @organization ||= Organization.find(params[:id])
  end

  def github_organization
    github_session.organizations.find { |org| org[:id] == organization[:gh_id] }
  end

  def ensure_organization_admin
    respond_api_error(401, message: "not_authorized") unless github_organization[:role] == "admin"
  end

  def public_enabled_params
    params.permit(:public_enabled)
  end

  def update_params
    params.permit(:public_enabled, :default_team_id)
  end

  def create_all_params
    params.permit(selected_organizations: [:login, :id, :avatar_url, :role])
  end

  def update_organization_default_team_memberships
    if organization.saved_change_to_attribute?(:default_team_id)
      GithubOrgMembershipService.new(token: @github_session.token)
                                .import_default_team_members(organization, params[:froggo_team])
    end
  end
end
