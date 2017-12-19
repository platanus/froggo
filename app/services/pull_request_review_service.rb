class PullRequestReviewService < PowerTypes::Service.new()
  def submit_review(request)
    p request['pull_request']['id']
    p request['pull_request']['state']
    p request['pull_request']['user']['login']
    p request['pull_request']['user']['id']
    p request['pull_request']['user']['avatar_url']
    p request['pull_request']['user']['html_url']
    p request['pull_request']['head']['repo']['id']
    p request['pull_request']['head']['repo']['full_name']
    p request['pull_request']['head']['repo']['owner']['login']
    p request['pull_request']['head']['repo']['owner']['id']
  end
end
