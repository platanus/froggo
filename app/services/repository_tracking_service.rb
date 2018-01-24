class RepositoryTrackingService < PowerTypes::Service.new(:repository, :token)
  def track
    clear_repository
    import_pull_requests_with_reviews
    set_repository_status(true)
  end

  private

  def clear_repository
    @repository.pull_requests.destroy_all
    @repository.pull_request_reviews.destroy_all
  end

  def import_pull_requests_with_reviews
    GithubPullRequestService.new(token: @token).import_all_from_repository(@repository)
    GithubPullRequestReviewService.new(token: @token).import_all_from_repository(@repository)
  end

  def set_repository_status(tracked)
    @repository.tracked = tracked
    @repository.save
  end
end
