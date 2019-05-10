class ProcessWebhookEvent < PowerTypes::Command.new(request: nil, event: nil)
  def perform
    if @event == 'pull_request'
      GithubPullRequestService.new(token: nil).handle_webhook_event(@request)
    elsif @event == 'pull_request_review'
      GithubPullRequestReviewService.new(token: nil).handle_webhook_event(@request)
    elsif @event == 'membership'
      Github::ProcessMembershipEvent.for(event_payload: @request)
    end
  end
end
