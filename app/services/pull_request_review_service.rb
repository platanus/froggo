class PullRequestReviewService < PowerTypes::Service.new(payload)
  def process
    submit_review if @payload[:action] == 'submitted'
  end

  def submit_review
    pull_req = PullRequest.find_by(gh_id: pull_request[:gh_id])
    github_user = GithubUser.find_by(login: user[:login])
    github_user ||= create_github_user(user)

    if !pull_req.has_reviewer?(github_user.id)
      pull_req.pull_request_relations.create!(
        pr_relation_type: :reviewer,
        github_user: github_user
      )
    end
  end

  def create_github_user(user_data)
    GithubUser.create!(
      gh_id: user_data[:gh_id],
      login: user_data[:login],
      avatar_url: user_data[:avatar_url],
      html_url: user_data[:html_url],
      tracked: true
    )
  end

  def user
    @user ||= {
      login: @payload[:review][:user][:login],
      gh_id: @payload[:review][:user][:id],
      avatar_url: @payload[:review][:user][:avatar_url],
      html_url: @payload[:review][:user][:html_url]
    }
  end

  def pull_request
    @pull_request ||= {
      gh_id: @payload[:pull_request][:id]
    }
  end
end
