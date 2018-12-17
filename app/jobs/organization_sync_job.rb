class OrganizationSyncJob < ApplicationJob
  def perform(org_sync, token)
    org_sync.execute!
    begin
      GithubOrgMembershipService.new(token: token)
                                .import_all_from_organization(org_sync.organization)
      GithubRepositoryService.new(token: token).import_all_from_organization(org_sync.organization)
      OrganizationCleanerService.new(token: token).clean(org_sync.organization)
      org_sync.complete!
    rescue
      org_sync.fail!
    end
  end
end
