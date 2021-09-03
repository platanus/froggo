class Api::V1::GithubUsersController < Api::V1::BaseController
  before_action :authenticate_github_user, only: [:open_prs, :logged_user]

  def team_review_recommendations
    response = { response: {
      recommendations: GetReviewRecommendations.for(
        github_user_id: github_user.id,
        other_users_ids: other_team_members_ids,
        month_limit: permitted_params[:month_limit]&.to_i,
        froggo_team_id: froggo_team_id
      )
    } }

    respond_with response
  end

  def organization_recommendation_statistics
    response = { response: {
      statistics: ComputeUserStatistics.for(
        github_user_id: github_user.id,
        organization_id: permitted_params[:org_id]
      )
    } }

    respond_with response
  end

  def pull_requests_information
    response = { response: {
      metrics: GetUserPullRequestMetrics.for(
        github_user: github_user,
        limit_month: permitted_params[:month_limit]
      )
    } }
    respond_with response
  end

  def update
    github_user = GithubUser.find(permitted_params[:id])
    github_user.update! update_params
    respond_with github_user
  end

  def open_prs
    gh_user = github_session.user
    response = { response: {
      github_username: gh_user.login,
      open_prs: gh_pr_service.open_prs(gh_user.login)
    } }
    respond_with response
  end

  def logged_user
    github_user = github_session.user
    respond_with github_user
  end

  def froggo_team_users
    froggo_team = FroggoTeam.find(permitted_params[:froggo_team_id])

    respond_with froggo_team.github_users
  end

  private

  def other_team_members_ids
    if permitted_params[:froggo_team] == "true"
      team = froggo_team
      team_members_gh_ids = team.github_users&.pluck(:gh_id)
    else
      team_members_gh_ids =
        github_session
        .get_team_members(permitted_params[:team_id].to_i)
        &.pluck(:id)
    end
    GithubUser
      .where(gh_id: team_members_gh_ids)
      .reject { |user| active_member(user) == false }
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

  def froggo_team
    @froggo_team ||= FroggoTeam.find_by!(id: permitted_params[:team_id])
  end

  def froggo_team_id
    @froggo_team_id ||= if permitted_params[:froggo_team] == "true"
                          froggo_team.id
                        end
  end

  def pr_relations
    @pr_relations ||= PullRequestRelation
                      .by_organizations(organization.id)
                      .within_dates(
                        permitted_params[:from] || Date.new,
                        permitted_params[:to] || Date.today
                      )
  end

  def active_member(user)
    if permitted_params[:froggo_team] == "false"
      return true
    end

    membership = FroggoTeamMembership.find_by(github_user: user, froggo_team: froggo_team)
    membership.is_member_active
  end

  def permitted_params
    params.permit(:org_id, :team_id, :github_login, :from, :to, :month_limit, :froggo_team,
                  :id, :description, :froggo_team_id)
  end

  def update_params
    params.permit(:description, tag_ids: [])
  end

  def gh_pr_service
    @gh_pr_service ||= GithubPullRequestService.new(token: github_session.token)
  end
end
