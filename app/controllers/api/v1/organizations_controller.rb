class Api::V1::OrganizationsController < Api::V1::BaseController
  before_action :authenticate_github_user
  # before_action :ensure_organization_admin

  def sync
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
    if organization.update_attributes(update_params)
      if organization.saved_change_to_attribute?(:default_team_id)
        GithubOrgMembershipService.new(token: @github_session.token)
                                  .import_default_team_members(organization)
      end
      render json: { response: 'Updated' }, status: 200
    else
      render json: { response: 'Bad request', errors: @user.errors.messages }, status: 400
    end
  end

  def update_public_enabled
    if organization.update_attributes(public_enabled_params)
      render json: { response: 'Updated' }, status: 200
    else
      render json: { response: 'Bad request', errors: @user.errors.messages }, status: 400
    end
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

  def public_enabled_params
    params.permit(:public_enabled)
  end

  def update_params
    params.permit(:public_enabled, :default_team_id)
  end
end
