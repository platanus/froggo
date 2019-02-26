module GithubAuthenticable
  extend ActiveSupport::Concern

  def authenticate_github_user
    return github_session if github_session.valid?

    redirect_to root_path
    nil
  end

  def github_session
    @github_session ||= GithubSession.new(cookies)
  end

  def github_user
    @github_user ||= github_session.user
  end
end
