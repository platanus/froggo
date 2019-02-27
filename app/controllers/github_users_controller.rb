class GithubUsersController < ApplicationController
  before_action :authenticate_github_user

  def show
    @github_user = github_user
    @teams = @github_session.fetch_teams_for_user @github_user
  end

  # GET /me
  def me
    redirect_to user_path(github_user)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
