class GithubSession
  attr_accessor :session, :name, :avatar_url, :organizations

  def initialize(cookies)
    @session = cookies

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
    token && !token.empty?
  end

  def set_session(_token, _session_type)
    @session.permanent['access_token'] = _token
    @session.permanent['client_type'] = _session_type
    set_user
    set_organizations
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

  def fetch_teams_for_user(github_login)
    teams = []
    client.organizations(github_login).each do |organization|
      begin
        teams << get_teams(organization)
      rescue Octokit::Error
        # Thrown, for example, when `octokit_client` has no visibility
        # of the organization's teams. Such teams are ignored.
      end
    end
    teams.flatten
  end

  def clean_session
    @session.permanent['access_token'] = ""
    @session.permanent['client_type'] = ""
  end

  def froggo_path
    @session[froggo_path_key]
  end

  def save_froggo_path(_path)
    @session.permanent[froggo_path_key] = _path
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

  def froggo_path_key
    "froggo_#{@name}_path"
  end

  def client
    @client ||= BuildOctokitClient.for(token: token)
  end
end
