class GithubUsersController < ApplicationController
  before_action :authenticate_github_user

  def show
    @github_user = GithubUser.find(params[:id])
    @github_session = github_session
    @teams = @github_session.fetch_teams_for_user(@github_user)
    @recommendations = GetReviewRecommendations.for(
      github_user_id: @github_user.id, other_users_ids: GithubUser.all.pluck(:id)
    )
  end

  # GET /me
  def me
    redirect_to user_path(github_user)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
