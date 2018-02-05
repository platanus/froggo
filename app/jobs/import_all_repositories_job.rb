class ImportAllRepositoriesJob < ApplicationJob
  def perform(organization, token)
    GithubRepositoryService.new(token: token).import_all_from_organization(organization)
  end
end
