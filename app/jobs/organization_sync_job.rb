class OrganizationSyncJob < ApplicationJob
  def perform(org_sync, token)
    GithubOrgMembershipService.new(token: token)
                              .import_all_from_organization(org_sync.organization)
    GithubRepositoryService.new(token: token).import_all_from_organization(org_sync.organization)
    org_sync.update! synced_at: DateTime.now
  end
end
