class FroggoTeamsController < ApplicationController
  before_action :authenticate_github_user
  def new
    @organization = Organization.find(params[:organization_id])
    @users = @organization.members
    @github_user = github_user
  end

  def index
    user = GithubUser.find(params[:github_user_id])
    @user_teams = user.froggo_teams.map { |team| team[:id] }
    @organizations = user.get_organizations_with_teams
    @github_user = github_user
  end

  def show
    @froggo_team = FroggoTeam.find(params[:id])
    @froggo_team_members = get_froggo_team_members(@froggo_team)
    @github_user = github_user
  end

  private

  def get_froggo_team_members(froggo_team)
    froggo_team.github_users.map do |member|
      {
        id: member.id,
        avatar_url: member.avatar_url,
        gh_id: member.gh_id,
        login: member.login,
        name: member.name,
        active: get_member_activation(member, froggo_team)
      }
    end
  end

  def get_member_activation(member, froggo_team)
    membership = FroggoTeamMembership.find_by(github_user: member, froggo_team: froggo_team)
    membership.is_member_active
  end
end
