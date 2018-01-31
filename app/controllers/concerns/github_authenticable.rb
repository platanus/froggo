module GithubAuthenticable
  extend ActiveSupport::Concern

  def authenticate_github_user
    return github_session if github_session.valid?

    redirect_to '/oauth'
    nil
  end

  def github_session
    @github_session ||= GithubSession.new(session)
  end
end
