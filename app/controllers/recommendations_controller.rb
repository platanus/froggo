class RecommendationsController < ApplicationController
  before_action :authenticate_github_user

  def show
    @teams = froggo_teams
    @organizations = @github_session.organizations
    @open_prs = open_prs(github_session.user)
  end

  private

  def froggo_teams
    github_session.user.get_froggo_teams.sort_by { |team| team[:name].downcase }
  end

  def open_prs(user)
    GithubPullRequestService.new(token: github_session.token).open_prs(user.login)
  end
end
