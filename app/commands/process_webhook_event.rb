class ProcessWebhookEvent < PowerTypes::Command.new(request: nil, event: nil)
  def perform
    if @event == 'pull_request'
      call_pull_request_event
    elsif @event == 'pull_request_review'
      call_pull_request_review_event
    end
  end

  def call_pull_request_event
    pr_service = PullRequestService.new
    case @request['action']
    when 'opened'
      pr_service.create_new_pull_request(@request)
    when 'closed'
      pr_service.close_pull_request(@request)
    when 'reopened'
      pr_service.reopen_pull_request(@request)
    when 'edited'
      pr_service.edit_pull_request(@request)
    when 'assigned'
      pr_service.assign_pull_request(@request)
    when 'unssigned'
      pr_service.unassign_pull_request(@request)
    end
  end

  def call_pull_request_review_event
    rev_service = PullRequestReviewService.new(request: @request)
    if @request['action'] == 'submitted'
      rev_service.submit_review
    end
  end
end
