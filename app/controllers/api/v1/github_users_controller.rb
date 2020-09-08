class Api::V1::GithubUsersController < Api::V1::BaseController
  before_action :authenticate_github_user, only: [:team_score]

  def team_score
    render json: { response: {
      score: compute_score_for_user(other_team_members_ids)
    } }, status: :ok
  end

  def organization_score
    render json: { response: {
      score: compute_score_for_user(
        organization.members.pluck(:id).reject { |id| id == github_user.id }
      )
    } }, status: :ok
  end

  def team_review_recommendations
    render json: { response: {
      recommendations: GetReviewRecommendations.for(
        github_user_id: github_user.id,
        other_users_ids: other_team_members_ids,
        month_limit: permitted_params[:month_limit]&.to_i
      )
    } }, status: :ok
  end

  def organization_recommendation_statistics
    render json: { response: {
      statistics: ComputeUserStatistics.for(
        github_user_id: github_user.id,
        organization_id: permitted_params[:org_id]
      )
    } }, status: :ok
  end

  def pull_requests_information
    render json: { response: {
      metrics: GetUserPullRequestMetrics.for(
        github_user: github_user,
        limit_month: permitted_params[:month_limit]
      )
    } }, status: :ok
  end

  private

  def compute_score_for_user(other_users_ids)
    contributions = ComputeGithubContributions.for(
      user_id: github_user.id,
      other_users_ids: other_users_ids,
      pr_relations: pr_relations
    )
    ContributionRanker::ComputeScore.for(
      self_reviewed_prs: contributions[:self_reviewed_prs],
      per_user_reviews: contributions[:per_user_contributions]
    )
  end

  def other_team_members_ids
    if permitted_params[:froggo_team] == "true"
      team = FroggoTeam.find(permitted_params[:team_id])
      team_members_gh_ids = team.github_users&.pluck(:gh_id)
    else
      team_members_gh_ids =
        github_session
        .get_team_members(permitted_params[:team_id].to_i)
        &.pluck(:id)
    end
    GithubUser
      .where(gh_id: team_members_gh_ids)
      .pluck(:id)
      .reject { |id| id == github_user.id }
      .sort
  end

  def organization
    @organization ||= Organization.find(permitted_params[:org_id])
  end

  def github_user
    @github_user ||= GithubUser.find_by(login: permitted_params[:github_login])
  end

  def pr_relations
    @pr_relations ||= PullRequestRelation
                      .by_organizations(organization.id)
                      .within_dates(
                        permitted_params[:from] || Date.new,
                        permitted_params[:to] || Date.today
                      )
  end

  def permitted_params
    params.permit(:org_id, :team_id, :github_login, :from, :to, :month_limit, :froggo_team)
  end
end
