class GithubUsersController < ApplicationController
  def show
    @github_user = GithubUser.find(params[:id])
    @github_session = github_session
    @teams = @github_session.fetch_teams_for_user(@github_user.login)
  end
end
