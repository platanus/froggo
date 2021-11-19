class GithubUsersController < ApplicationController
  before_action :authenticate_github_user

  def show
    @github_user = GithubUser.find(params[:id])
    @teams = github_user.froggo_teams
    @organizations = @github_user.organizations
    @user_tags = @github_user.tags
    @tags = Tag.all
  end

  # GET /me
  def me
    redirect_to user_path(github_user)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
