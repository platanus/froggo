class Github::ProcessMembershipEvent < PowerTypes::Command.new(:event_payload)
  def perform
    read_payload
    return unless event_team_is_default_team?

    @organization_membership.update!(is_member_of_default_team: member_of_default_team?)
  end

  private

  def read_payload
    @event_action = data.action
    @organization = Organization.find_by(gh_id: data.organization.id)
    @user = GithubUser.find_by(gh_id: data.member.id)
    @github_team_id = data.team.id
    @organization_membership = OrganizationMembership.find_by(
      github_user_id: @user.id,
      organization_id: @organization.id
    )
  end

  def event_action_is_added?
    @event_action === "added"
  end

  def event_action_is_removed?
    @event_action === "removed"
  end

  def event_team_is_default_team?
    @github_team_id === @organization.default_team_id
  end

  def data
    @data ||= @event_payload.is_a?(Hash) ? RecursiveOpenStruct.new(@event_payload) : @event_payload
  end

  def member_of_default_team?
    return true if event_action_is_added?

    return false if event_action_is_removed?

    nil
  end
end
