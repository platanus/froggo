class ProcessWebhookEvent < PowerTypes::Command.new(request: nil, event: nil)
  def perform
    case @event
    when 'pull_request'
      GithubPullRequestService.new(token: nil).handle_webhook_event(@request)
    when 'pull_request_review'
      GithubPullRequestReviewService.new(token: nil).handle_webhook_event(@request)
    when 'membership'
      Github::ProcessMembershipEvent.for(event_payload: @request)
    end
  end
end
