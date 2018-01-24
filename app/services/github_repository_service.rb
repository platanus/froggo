class GithubRepositoryService < PowerTypes::Service.new(:token)
  def set_webhook(repository)
    github_response = set_github_webhook(repository)
    create_hook(github_response, repository) unless github_response == Octokit::NotFound
  end

  def remove_webhook(repository)
    github_response = remove_github_webhook(repository)
    destroy_hook(repository) if github_response == true
  end

  def import_all_from_organization(organization)
    # Obtain list of repositories for organization and save in DB.
  end

  def handle_webhook_event(data)
    # Receive repository event (create or delete) and process it.
  end

  private

  def create_hook(response, resource)
    @hook = Hook.create(
      gh_id: response[:id],
      name: response[:name],
      active: response[:active],
      ping_url: response[:ping_url],
      test_url: response[:test_url],
      resource: resource,
      hook_type: response[:type]
    )
  end

  def destroy_hook(repository)
    Hook.find_by(resource_id: repository.id,
                 resource_type: 'Repository').destroy
    true
  end

  def set_github_webhook(repository)
    client.create_hook(repository.full_name,
      'web',
      hook_repository_config,
      hook_repository_options)
  rescue Octokit::NotFound => ex
    logger.error ex
    Octokit::NotFound
  end

  def remove_github_webhook(repository)
    return false if Hook.find_by(resource_id: repository.id,
                                 resource_type: 'Repository').nil?
    client.remove_hook(
      repository.full_name,
      Hook.find_by(resource_id: repository.id,
                   resource_type: 'Repository').gh_id
    )
  rescue Octokit::NotFound => ex
    logger.error ex
    true
  end

  def hook_repository_config
    {
      url: "#{ENV['APPLICATION_HOST']}/github_events",
      content_type: 'json',
      secret: ENV['GH_HOOK_SECRET']
    }
  end

  def hook_repository_options
    {
      events: ['pull_request', 'pull_request_review'],
      active: true
    }
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end
end