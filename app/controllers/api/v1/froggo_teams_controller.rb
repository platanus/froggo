class Api::V1::FroggoTeamsController < Api::V1::BaseController
  before_action :authenticate_github_user
  def index
    render json: { froggo_teams: organization.froggo_teams }
  end

  def create
    render(json: { error: "permission denied" }, status: :bad_request) && return unless valid_user?

    if name_validated?
      new_froggo_team = FroggoTeam.create!(name: permitted_params[:name],
                                           organization: organization)
      permitted_params[:new_members_ids].each do |member_id|
        add_member(member_id, new_froggo_team)
      end
      respond_with new_froggo_team
    else
      render(json: { error: "name already exists for organization" }, status: :bad_request)
    end
  end

  def show
    respond_with froggo_team
  end

  def update
    render(json: { error: "permission denied" }, status: :bad_request) && return unless valid_user?

    if name_validated?
      froggo_team.update(name: permitted_params[:name])
      respond_with froggo_team
    else
      render(json: { error: "name already exists for organization" }, status: :bad_request)
    end
  end

  def destroy
    render(json: { error: "permission denied" }, status: :bad_request) && return unless valid_user?

    froggo_team.destroy
  end

  def remove_member
    render(json: { error: "permission denied" }, status: :bad_request) && return unless valid_user?

    membership = FroggoTeamMembership.find_by(github_user: github_user, froggo_team: froggo_team)
    membership.destroy
  end

  private

  def permitted_params
    params.permit(:name, :id, :organization_id, :github_login, new_members_ids: [])
  end

  def froggo_team
    @froggo_team ||= FroggoTeam.find_by(id: permitted_params[:id])
  end

  def organization
    @organization ||= if params.include?("organization_id")
                        Organization.find(permitted_params[:organization_id])
                      else
                        froggo_team.organization
                      end
  end

  def github_user
    @github_user ||= GithubUser.find_by(login: permitted_params[:github_login])
  end

  def valid_user?
    @valid_user ||= organization.members.include?(github_session.user)
  end

  def valid_member?
    @valid_member ||= organization.members.include?(github_user)
  end

  def name_validated?
    @name_validated ||= validate_team_name(permitted_params[:name], organization)
  end

  def validate_team_name(name, organization)
    organization.froggo_teams.each do |team|
      return false if team.name == name
    end
    true
  end

  def add_member(user_id, team)
    if organization.members.exists?(user_id)
      FroggoTeamMembership.create(github_user: GithubUser.find_by(id: user_id), froggo_team: team)
    end
  end
end
