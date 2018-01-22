class GithubSession
  def initialize(name, token, orgs, session)
    @name = name
    @token = token
    @organizations = orgs
    @session_type = session
  end
end
