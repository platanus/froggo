class GithubOrgMembershipService < PowerTypes::Service.new(:token)
  def import_all_from_organization(org)
    persisted_memb_ids = org.members.pluck(:gh_id)
    new_members = github_org_members(org).reject { |member| persisted_memb_ids.include?(member.id) }

    user_service = GithubUserService.new
    new_members.each do |member|
      org.organization_memberships.create(github_user: user_service.find_or_create(member))
    end
  end

  def ex_members_ids(org)
    org.members.where.not(gh_id: github_org_members(org).map(&:id)).pluck(:id)
  end

  def delete_ex_members(org, ids)
    org.organization_memberships.where(github_user_id: ids).destroy_all
    org.members.where(id: ids).destroy_all
  end

  def import_default_team_members(org, froggo_team)
    all_memberships = OrganizationMembership.where(organization_id: org.id)
    all_memberships.each do |membership|
      membership.update!(is_member_of_default_team: false)
    end
    default_team_members = if froggo_team
                             FroggoTeam.find(org.default_team_id).github_users
                           else
                             get_github_users(client.team_members(org.default_team_id))
                           end
    default_team_members.each do |member|
      org_membership = all_memberships.find_by(github_user_id: member&.id)
      org_membership&.update!(is_member_of_default_team: true)
    end
  end

  private

  def github_org_members(org)
    client.org_members(org.login)
  end

  def get_github_users(team_members)
    team_members.map { |member| GithubUser.find_by(gh_id: member.id) }
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end
end
