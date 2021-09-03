class Api::V1::FroggoTeamsController < Api::V1::BaseController
  before_action :authenticate_github_user
  def index
    respond_with organization.froggo_teams, with_users: permitted_params[:with_users] == 'true'
  end

  def create
    return render(json: { error: "permission denied" }, status: :unauthorized) unless valid_user?

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
    return render(json: { error: "permission denied" }, status: :unauthorized) unless valid_user?

    if permitted_params.has_key?(:name)
      if name_validated?
        froggo_team.update(name: permitted_params[:name])
      else
        return render(json: { error: "name exists in organization" }, status: :bad_request)
      end
    end
    add_members(permitted_params[:new_members_ids])
    remove_members(permitted_params[:old_members_ids])
    update_members_activation
    update_members_percentage
    respond_with froggo_team
  end

  def destroy
    return render(json: { error: "permission denied" }, status: :unauthorized) unless valid_user?

    froggo_team.destroy
  end

  private

  def permitted_params
    params
      .permit(:name,
              :id,
              :organization_id,
              :github_login,
              :with_users,
              new_members_ids: [],
              old_members_ids: [],
              changed_members_ids: [],
              changed_percentages: {})
      .with_defaults(new_members_ids: [], old_members_ids: [])
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

  def remove_member(user_id, team)
    github_user = GithubUser.find_by(id: user_id)
    membership = FroggoTeamMembership.find_by(github_user: github_user, froggo_team: team)
    membership.destroy
  end

  def add_members(new_ids_list)
    new_ids_list.each do |member_id|
      add_member(member_id, froggo_team)
    end
  end

  def remove_members(old_ids_list)
    old_ids_list.each do |member_id|
      remove_member(member_id, froggo_team)
    end
  end

  def update_members_activation
    return unless permitted_params.has_key?(:changed_members_ids)

    permitted_params[:changed_members_ids].each do |member_id|
      github_user = GithubUser.find_by(id: member_id)
      membership = FroggoTeamMembership.find_by(github_user: github_user, froggo_team: froggo_team)
      membership.update(is_member_active: !membership.is_member_active)
    end
  end

  def update_members_percentage
    return unless permitted_params.has_key?(:changed_percentages)

    permitted_params[:changed_percentages].each do |member_id, percentage|
      membership = FroggoTeamMembership.find_by(github_user_id: member_id, froggo_team: froggo_team)
      membership.update(assignment_percentage: percentage)
    end
  end
end
