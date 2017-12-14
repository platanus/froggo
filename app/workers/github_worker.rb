class GithubWorker
  include Sidekiq::Worker

  def perform(action, payload)
    case action
    when "FETCH_ORG_REPOS"
      organization = Organization.find(payload["organization_id"])
      service = GithubService.new(user: organization.owner)
      service.create_organization_repositories(organization.login)
    end
  end
end
