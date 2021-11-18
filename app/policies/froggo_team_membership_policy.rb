class FroggoTeamMembershipPolicy < ApplicationPolicy
  def update?
    organization_matches?
  end

  private

  def organization_matches?
    user.organizations.include?(froggo_team_membership_organization)
  end

  def froggo_team_membership_organization
    FroggoTeam.find(record.froggo_team_id).organization
  end
end
