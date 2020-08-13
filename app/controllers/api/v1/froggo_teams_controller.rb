class Api::V1::FroggoTeamsController < Api::V1::BaseController
  before_action :authenticate_github_user
  def index
    render json: { froggo_teams: github_session.user.froggo_teams }
  end

  def create
    froggo_team_service = FroggoTeamService.new
    valid_member = froggo_team_service.validate_member(github_session.user, organization)
    render(json: { error: "permission denied" }, status: :bad_request) && return unless valid_member

    name_validated = froggo_team_service.validate_team_name(permitted_params[:name], organization)
    if name_validated
      new_froggo_team = FroggoTeam.create!(name: permitted_params[:name],
                                           organization: organization)
      respond_with new_froggo_team
    else
      render(json: { error: "name already exists for organization" }, status: :bad_request)
    end
  end

  def show
    respond_with froggo_team
  end

  def update
    froggo_team_service = FroggoTeamService.new
    organization = Organization.find(froggo_team.organization.id)
    valid_member = froggo_team_service.validate_member(github_session.user, organization)
    render(json: { error: "permission denied" }, status: :bad_request) && return unless valid_member

    name_validated = froggo_team_service.validate_team_name(permitted_params[:name], organization)
    if name_validated
      froggo_team.update(name: permitted_params[:name])
      respond_with froggo_team
    else
      render(json: { error: "name already exists for organization" }, status: :bad_request)
    end
  end

  def destroy
    froggo_team_service = FroggoTeamService.new
    organization = Organization.find(froggo_team.organization.id)
    valid_member = froggo_team_service.validate_member(github_session.user, organization)
    render(json: { error: "permission denied" }, status: :bad_request) && return unless valid_member

    froggo_team.destroy
  end

  private

  def permitted_params
    params.permit(:name, :id, :org_id)
  end

  def organization
    @organization ||= Organization.find(permitted_params[:org_id])
  end

  def froggo_team
    @froggo_team ||= FroggoTeam.find_by(id: permitted_params[:id])
  end
end
