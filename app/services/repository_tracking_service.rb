class RepositoryTrackingService < PowerTypes::Service.new(:repository, :token)
  def track
    set_repository_status(true)
    clear_repository
    import_pull_requests_with_reviews
    set_repository_webhook
  end

  def untrack
    set_repository_status(false)
    sleep(0.5) # Wait for other process to check untracked status and stop creating pull requests
    clear_repository
    remove_repository_webhook
  end

  private

  def clear_repository
    @repository.pull_requests.destroy_all
  end

  def import_pull_requests_with_reviews
    GithubPullRequestService.new(token: @token).import_all_from_repository(@repository)
  end

  def set_repository_webhook
    GithubRepositoryService.new(token: @token).set_webhook(@repository)
  end

  def remove_repository_webhook
    GithubRepositoryService.new(token: @token).remove_webhook(@repository)
  end

  def set_repository_status(tracked)
    @repository.tracked = tracked
    @repository.save
  end
end
