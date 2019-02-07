class GithubUsersController < ApplicationController
  def show
    @github_user = GithubUser.find(params[:id])
    # Set github_session so that the header partial
    # has access to its data.
    @github_session = github_session
    @teams =
      GithubUserService
      .new
      .fetch_teams_for_user(@github_user.login, @github_session.client)
  end
end
