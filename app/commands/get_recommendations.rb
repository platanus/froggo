class GetRecommendations < PowerTypes::Command.new(:github_user, :organization)
  def perform
    if membership&.is_member_of_default_team
      GetReviewRecommendations.for(
        github_user_id: @github_user.id,
        team_users_ids: other_default_team_members_id
      )
    end
  end

  private

  def membership
    @membership ||= OrganizationMembership.find_by(github_user_id: @github_user.id,
                                                   organization_id: @organization.id)
  end

  def other_default_team_members_id
    OrganizationMembership
      .where(organization_id: @organization.id, is_member_of_default_team: true)
      .pluck(:github_user_id)
      .reject { |id| id == @github_user.id }
      .sort
  end
end
