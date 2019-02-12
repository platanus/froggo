class Api::V1::OrganizationsController < Api::V1::BaseController
  before_action :authenticate_github_user
  before_action :ensure_organization_admin, only: [:sync, :check_sync, :update_public_enabled]

  def sync
    OrganizationSyncJob.perform_later(
      OrganizationSync.find_or_create_by(organization: organization),
      @github_session.token
    )
    respond_with organization, status: 202
  end

  def check_sync
    respond_with OrganizationSync.find_by(organization_id: params[:id])
  end

  def update_public_enabled
    if organization.update_attributes(public_enabled_params)
      render json: { response: 'Updated' }, status: 200
    else
      render json: { response: 'Bad request', errors: @user.errors.messages }, status: 400
    end
  end

  def users_score_within_team
    organization = Organization.find(score_params[:org_id])
    user_id = score_params[:user_id].to_i
    other_users_ids = other_team_members_ids(
      user_id,
      github_session.find_team_in_organization(organization, score_params[:team])
    )
    pr_relations = PullRequestRelation
                   .by_organizations(organization.id)
                   .within_week_limit(score_params[:weeks].to_i || 1)
    render json: { response: {
      score: compute_score_for_user(user_id, other_users_ids, pr_relations)
    } }, status: 200
  end

  private

  def other_team_members_ids(user_id, team)
    team_members_gh_ids = github_session.get_team_members(team)&.pluck(:id)
    GithubUser
      .where(gh_id: team_members_gh_ids)
      .map(&:id)
      .reject { |id| id == user_id }
  end

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

  def organization
    @organization ||= Organization.find(params[:id])
  end

  def github_organization
    github_session.organizations.find { |org| org[:id] == organization[:gh_id] }
  end

  def ensure_organization_admin
    respond_api_error(401, "not_authorized", nil) unless github_organization[:role] == "admin"
  end

  def public_enabled_params
    params.permit(:public_enabled)
  end

  def score_params
    params.permit(:org_id, :team, :user_id, :weeks)
  end
end
