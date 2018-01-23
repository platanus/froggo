class GithubPullRequestService < PowerTypes::Service.new(:token)
  def import_all_from_repository(repository)
    # Obtain list of pull request from repository and persist them in DB.
  end

  def handle_webhook_event(data)
    # Receive a pull request event (CRUD) and process it.
  end

  private

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end
end
