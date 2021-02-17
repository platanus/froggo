class GithubUsersController < ApplicationController
  before_action :authenticate_github_user

  def show
    @github_user = GithubUser.find(params[:id])
    @teams = froggo_teams
    @organizations = @github_user.organizations
    @user_tags = @github_user.tags
    @tags = Tag.all
    @open_prs = open_prs(github_user)
  end

  # GET /me
  def me
    redirect_to user_path(github_user)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  private

  def github_teams(github_user)
    github_session.fetch_teams_for_user(github_user)
  end

  def froggo_teams
    github_session.user.get_froggo_teams.sort_by { |team| team[:name].downcase }
  end

  def client
    @client ||= BuildOctokitClient.for(token: github_session.token)
  end

  def user_teams(github_user)
    gh_teams = github_teams(github_user)
    gh_teams.each do |team|
      team[:froggo_team] = false
    end
    gh_teams.concat(froggo_teams)
            .sort_by { |team| team[:name].downcase }
  end

  def check_pr_status!(pull_request)
    repo = pull_request.repository.full_name
    gh_number = pull_request.gh_number
    updated_pull_request = client.pull_request(repo, gh_number)
    response = client.last_response
    if response && response.status == 200 && updated_pull_request[:state] != 'open'
      pull_request.update(pr_state: updated_pull_request[:state])
    end
  end

  def check_open_prs(github_user)
    PullRequest.by_owner(github_user.login).where(pr_state: 'open').each do |pr|
      if pr.gh_created_at < 1.day.ago
        check_pr_status!(pr)
      end
    end
  end

  def open_prs(github_user)
    check_open_prs(github_user)
    PullRequest.by_owner(github_user.login).where(pr_state: 'open')
  end
end
