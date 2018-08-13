class GithubSession
  attr_accessor :session, :name, :avatar_url, :organizations

  def initialize(session)
    @session = session

    if valid?
      set_user
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

  def get_teams(organization)
    client.organization_teams(organization[:login])
          .sort_by { |team| team[:slug] }
          .map { |team| { id: team.id, name: team.name, slug: team.slug } }
  end

  def get_team_members(team)
    client.team_members(team[:id]).map do |member|
      {
        id: member.id,
        login: member.login
      }
    end
  end

  private

  def set_user
    user = client.user

    @name = user['login']
    @avatar_url = user['avatar_url']
  end

  def set_organizations
    @organizations = client.organization_memberships.map do |mem|
      {
        id: mem.organization.id,
        login: mem.organization.login,
        role: mem.role,
        avatar_url: mem.organization.avatar_url
      }
    end
  end

  def client
    @client ||= BuildOctokitClient.for(token: token)
  end
end
