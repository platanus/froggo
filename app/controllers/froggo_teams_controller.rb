class FroggoTeamsController < ApplicationController
  def new
    @organization = Organization.find(params[:organization_id])
    @users = @organization.members
  end

  def index
    user = GithubUser.find(params[:github_user_id])
    @user_teams = user.froggo_teams
    @organizations = user.organizations
  end
end
