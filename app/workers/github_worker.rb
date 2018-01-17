class GithubWorker
  include Sidekiq::Worker

  def perform(action, payload)
    case action
    when 'FETCH_ORG_REPOS'
      organization = Organization.find(payload['organization_id'])
      service = GithubService.new(user_token: organization.owner.token,
                                  user_id: organization.owner.id)
      service.create_organization_repositories(organization)
    when 'FETCH_REPOS_PULL_REQUEST'
      owner = AdminUser.find(payload['owner_id'])
      repository = Repository.find(payload['repository_id'])
      service = GithubService.new(user_token: owner.token, user_id: owner.id)
      service.create_repository_pull_requests(repository.id, repository.full_name)
    end
  end
end
