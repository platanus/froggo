class PullRequestService < PowerTypes::Service.new(payload: nil)
  def process

  end

  def create_new_pull_request(request)

  end

  def close_pull_request(request)

  end

  def reopen_pull_request(request)

  end

  def edit_pull_request(request)

  end

  def assign_pull_request(request)
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

  def unassign_pull_request(request)
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
