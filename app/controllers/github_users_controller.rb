class GithubUsersController < ApplicationController
  before_action :authenticate_github_user

  def show
    @github_user = GithubUser.find(params[:id])
    @teams = froggo_teams
    @organizations = @github_user.organizations
  end

  # GET /me
  def me
    redirect_to user_path(github_user)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  private

  def github_teams(github_user)
    github_session.fetch_teams_for_user(github_user)
  end

  def froggo_teams
    github_session.user.get_froggo_teams.sort_by { |team| team[:name].downcase }
  end

  def user_teams(github_user)
    gh_teams = github_teams(github_user)
    gh_teams.each do |team|
      team[:froggo_team] = false
    end
    gh_teams.concat(froggo_teams)
            .sort_by { |team| team[:name].downcase }
  end
end
