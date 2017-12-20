class PullRequestService < PowerTypes::Service.new(payload: nil)
  def process
    case @payload[:action]
    when 'opened'
      create_pull_request
    when 'closed', 'reopened', 'edited'
      update_pull_request
    end
  end

  def create_pull_request
    pull_request
  end

  def update_pull_request
    pull_request.update! pull_request_params
    pull_request.assignees << merger if merger && !pull_request.has_assignee?(merger.id)
  end

  def pull_request_params
    {
      gh_id: @payload[:pull_request][:id],
      title: @payload[:pull_request][:title],
      gh_number: @payload[:pull_request][:number],
      pr_state: @payload[:pull_request][:state],
      html_url: @payload[:pull_request][:html_url],
      gh_created_at: @payload[:pull_request][:created_at],
      gh_updated_at: @payload[:pull_request][:updated_at],
      gh_closed_at: @payload[:pull_request][:closed_at],
      gh_merged_at: @payload[:pull_request][:merged_at],
      owner_id: owner.id,
      repository_id: repo.id
    }
  end

  def pull_request
    @pull_request ||= PullRequest.create_with(pull_request_params)
                                 .find_or_create_by(gh_id: pull_request_params[:gh_id])
  end

  def owner
    @owner ||= get_gh_user @payload[:pull_request][:user]
  end

  def merger
    unless @payload[:pull_request][:merged_by].nil?
      @merger ||= get_gh_user @payload[:pull_request][:merged_by]
    end
  end

  def get_gh_user(user)
    GithubUser.create_with(
      login: user[:login],
      avatar_url: user[:avatar_url],
      html_url: user[:html_url]
    ).find_or_create_by!(gh_id: user[:id])
  end

  def repo
    @repo ||= Repository.find_by(gh_id: @payload[:repository][:id])
  end
end
