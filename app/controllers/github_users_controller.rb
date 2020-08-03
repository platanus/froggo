class GithubUsersController < ApplicationController
  before_action :authenticate_github_user

  def show
    @github_user = GithubUser.find(params[:id])
    @teams = github_session.fetch_teams_for_user(@github_user)
    @organizations = @github_user.organizations
  end

  # GET /me
  def me
    redirect_to user_path(github_user)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
