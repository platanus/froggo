class Api::V1::GithubUsersController < Api::V1::BaseController
  before_action :authenticate_github_user

  def score
    organization = Organization.find(score_params[:org_id])
    user_id = GithubUser.find_by(login: score_params[:github_login]).id
    other_users_ids = if score_params[:team_id]
                        other_team_members_ids(user_id, score_params[:team_id].to_i)
                      else
                        organization.members.pluck(:id)
                      end
    pr_relations = PullRequestRelation
                   .by_organizations(organization.id)
                   .within_week_limit(score_params[:weeks].to_i || 1)
    render json: { response: {
      score: compute_score_for_user(user_id, other_users_ids, pr_relations)
    } }, status: 200
  end

  private

  def compute_score_for_user(user_id, other_users_ids, pr_relations)
    contributions = ComputeGithubContributions.for(
      user_id: user_id,
      other_users_ids: other_users_ids,
      pr_relations: pr_relations
    )
    ContributionRanker::ComputeScore.for(
      self_reviewed_prs: contributions[:self_reviewed_prs],
      per_user_reviews: contributions[:per_user_contributions]
    )
  end

  def other_team_members_ids(user_id, team_id)
    team_members_gh_ids = github_session.get_team_members(team_id)&.pluck(:id)
    GithubUser
      .where(gh_id: team_members_gh_ids)
      .pluck(:id)
      .reject { |id| id == user_id }
  end

  def score_params
    params.permit(:org_id, :team_id, :github_login, :weeks)
  end
end
