class GithubWorker
  include Sidekiq::Worker

  def perform(action, payload)
    case action
    when 'FETCH_ORG_REPOS'
      organization = Organization.find(payload['organization_id'])
      service = GithubService.new(user: organization.owner)
      service.create_organization_repositories(organization.login)
    when 'FETCH_REPOS_PULL_REQUEST'
      owner = AdminUser.find(payload['owner_id'])
      repository = Repository.find(payload['repository_id'])
      service = GithubService.new(user: owner)
      service.create_repository_pull_requests(repository.id, repository.full_name)
    end
  end
end
