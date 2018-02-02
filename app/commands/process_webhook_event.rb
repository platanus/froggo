class ProcessWebhookEvent < PowerTypes::Command.new(request: nil, event: nil)
  def perform
    # TODO: this should use the new GithubServices

    # if @event == 'pull_request'
    #   PullRequestService.new(payload: @request).process
    # elsif @event == 'pull_request_review'
    #   PullRequestReviewService.new(payload: @request).process
    # elsif @event == 'repository'
    #   RepositoryService.new(payload: @request).process
    # end
  end
end
