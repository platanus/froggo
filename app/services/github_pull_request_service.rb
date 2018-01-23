class GithubPullRequestService < PowerTypes::Service.new
  def import_all_from_repository(repository)
    # Obtain list of pull request from repository and persist them in DB.
  end

  def handle_webhook_event(data)
    # Receive a pull request event (CRUD) and process it.
  end
end
