class GithubSession
  attr_reader :session

  def initialize(cookies)
    @session = cookies
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

  def user
    @user ||= GithubUserService.new.find_or_create client.user
  end

  def organizations
    @organizations ||= client.organization_memberships.map do |mem|
      {
        id: mem.organization.id,
        login: mem.organization.login,
        role: mem.role,
        avatar_url: mem.organization.avatar_url
      }
    end
  end

  def set_session(_token, _session_type)
    @session.permanent['access_token'] = _token
    @session.permanent['client_type'] = _session_type
  end

  def get_teams(organization)
    client.organization_teams(organization[:login])
          .sort_by { |team| team[:slug] }
          .map do |team|
            {
              id: team.id,
              name: team.name,
              slug: team.slug,
              organization_id: organization[:id]
            }
          end
  end

  def get_team_members(team_id)
    client.team_members(team_id).map do |member|
      {
        id: member.id,
        login: member.login
      }
    end
  end

  def fetch_teams_for_user(github_user)
    teams = []
    github_user.organizations.each do |organization|
      begin
        all_teams = get_teams(organization)
        all_teams.each do |team|
          teams << team if client.team_member?(team[:id], github_user.login)
        end
      rescue Octokit::Error
        # Octokit::Error Thrown, for example, when `octokit_client` has
        # no visibility of the organization's teams. Such teams are ignored.
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

  def froggo_path_key
    "froggo_#{user.login}_path"
  end

  def client
    @client ||= BuildOctokitClient.for(token: token)
  end
end
