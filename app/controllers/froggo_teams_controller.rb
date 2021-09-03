class FroggoTeamsController < ApplicationController
  before_action :authenticate_github_user
  def new
    @organization = Organization.find(params[:organization_id])
    @users = @organization.members
    @github_user = github_user
  end

  def index
    user = GithubUser.find(params[:github_user_id])
    @user_teams = user.froggo_teams
    @organizations = user.get_organizations_with_teams
    @github_user = github_user
  end

  def show
    @froggo_team = FroggoTeam.find(params[:id])
    @froggo_team_members = froggo_team_members(@froggo_team)
    @github_user = github_user
  end

  def edit
    @froggo_team = FroggoTeam.find(params[:id])
    @froggo_team_members = @froggo_team.github_users
    @organization_members = @froggo_team.organization.members.all_except(@froggo_team_members)
    @github_user = github_user
  end

  private

  def froggo_team_members(froggo_team)
    froggo_team.github_users.map do |member|
      member_info(member, froggo_team)
    end
  end

  def member_info(member, froggo_team)
    membership = FroggoTeamMembership.find_by(github_user: member, froggo_team: froggo_team)
    {
      id: member.id,
      avatar_url: member.avatar_url,
      gh_id: member.gh_id,
      login: member.login,
      name: member.name,
      active: membership.is_member_active,
      percentage: membership.assignment_percentage
    }
  end
end
