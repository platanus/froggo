class Api::V1::FroggoTeamMembershipsController < Api::V1::BaseController
  before_action :authenticate_github_user

  def index
    respond_with github_user.froggo_team_memberships
  end

  def update
    authorize froggo_team_membership
    froggo_team_membership.update! update_params
    respond_with froggo_team_membership
  end

  def update_all
    ActiveRecord::Base.transaction do
      github_user.froggo_team_memberships.each { |x| x.update!(update_params) }
    end
    respond_with github_user.froggo_team_memberships
  end

  private

  def froggo_team_membership
    @froggo_team_membership ||= FroggoTeamMembership.find(params[:id])
  end

  def github_user
    @github_user ||= GithubUser.find(params[:github_user_id])
  end

  def update_params
    params.permit(:is_member_active)
  end

  def pundit_user
    github_session.user
  end
end
