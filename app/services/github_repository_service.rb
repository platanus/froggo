class GithubRepositoryService < PowerTypes::Service.new
  def set_github_webhook(repository)
    # Subscribe webhook in github for PR and Reviews events.
  end

  def remove_github_webhook(repository)
    # Unsubscribe webhook in github.
  end

  def import_all_from_organization(organization)
    # Obtain list of repositories for organization and save in DB.
  end

  def handle_webhook_event(data)
    # Receive repository event (create or delete) and process it.
  end
end
