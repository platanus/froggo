class ProcessWebhookEvent < PowerTypes::Command.new(request: nil, event: nil)
  def perform
    if @event == 'pull_request'
      PullRequestService.new(payload: @request).process
    elsif @event == 'pull_request_review'
      PullRequestReviewService.new(payload: @request).process
    end
  end
end
