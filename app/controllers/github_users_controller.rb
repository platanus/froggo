class GithubUsersController < ApplicationController
  before_action :authenticate_github_user

  def show
    @github_user = GithubUser.find(params[:id])
    @github_session = github_session
    @teams = @github_session.fetch_teams_for_user(@github_user.login)
  end

  # GET /me
  def me
    redirect_to user_path(GithubUser.find_by!(name: github_session.name))
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
