class GithubOrgMembershipService < PowerTypes::Service.new(:token)
  def import_all_from_organization(org)
    persisted_memb_ids = org.members.pluck(:gh_id)
    new_members = github_org_members(org).reject { |member| persisted_memb_ids.include?(member.id) }

    user_service = GithubUserService.new
    new_members.each do |member|
      org.organization_memberships.create(github_user: user_service.find_or_create(member))
    end
  end

  private

  def github_org_members(org)
    client.org_members(org.login)
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end
end
