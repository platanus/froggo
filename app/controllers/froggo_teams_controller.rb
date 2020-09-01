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
    @organizations = user.organizations
    @github_user = github_user
  end

  def show
    @froggo_team = FroggoTeam.find(params[:id])
    @froggo_team_members = @froggo_team.github_users
    @organization_members = @froggo_team.organization.members.all_except(@froggo_team_members)
    @github_user = github_user
  end
end
