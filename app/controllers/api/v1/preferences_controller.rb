class Api::V1::PreferencesController < Api::V1::BaseController
  def show
    authorize preference
    respond_with preference
  end

  def update
    authorize preference
    preference.update! update_params
    respond_with preference
  end

  private

  def preference
    @preference ||= github_user.preference
  end

  def github_user
    @github_user ||= GithubUser.find_by(id: permitted_params[:id])
  end

  def permitted_params
    params.permit(:id)
  end

  def update_params
    params.permit(:default_organization_id, :default_team_id, :default_time)
  end

  def pundit_user
    github_session.user
  end
end
