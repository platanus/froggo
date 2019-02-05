class GithubUsersController < ApplicationController
  def show
    @github_user = GithubUser.find(params[:id])
    # Set github_session so that the header partial
    # has access to its data.
    @github_session = github_session
  end
end
