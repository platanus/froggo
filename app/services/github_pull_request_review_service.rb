class GithubPullRequestReviewService < PowerTypes::Service.new
  def import_all_from_repository(repository)
    # Obtain list of reviews for each PR of the repository and pull request
    # and persist them in DB.
  end

  def handle_webhook_event(data)
    # Receive review event and process it.
  end
end
