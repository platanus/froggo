class SyncRepositoriesJob < ApplicationJob
  def perform(repo_sync, token)
    GithubRepositoryService.new(token: token).import_all_from_organization(repo_sync.organization)
    repo_sync.update! synced_at: DateTime.now
  end
end
