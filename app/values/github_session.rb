class GithubSession
  attr_accessor :session, :name, :organizations

  def initialize(session)
    @session = session

    if valid?
      set_name
      set_organizations
    end
  end

  def token
    @session['access_token']
  end

  def session_type
    @session['client_type']
  end

  def valid?
    !token.nil?
  end

  def set_access_token(_token)
    @session['access_token'] = _token
  end

  def set_session_type(_session_type)
    @session['client_type'] = _session_type
  end

  private

  def set_name
    @name = client.user['login']
  end

  def set_organizations
    @organizations = client.organization_memberships.map do |mem|
      {
        id: mem.organization.id,
        login: mem.organization.login,
        role: mem.role
      }
    end
  end

  def client
    @client ||= BuildOctokitClient.for(token: token)
  end
end
