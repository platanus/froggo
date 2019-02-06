class GithubUserService < PowerTypes::Service.new
  def find_or_create(github_user_params)
    GithubUser.create_with(
      login: github_user_params.login,
      avatar_url: github_user_params.avatar_url,
      html_url: github_user_params.html_url,
      email: github_user_params.email,
      name: github_user_params.name
    ).find_or_create_by!(gh_id: github_user_params.id)
  end

  # Performs a request to retrieve all teams associated
  # to the github username given by `github_login`.
  # Teams' visiblity depends on authentication privileges
  # in `octokit_client`.
  def fetch_teams_for_user(github_login, octokit_client)
    organizations_logins =
      octokit_client
        .organizations(github_login)
        .map do |organization|
          organization.login
        end
    teams = []
    organizations_logins.each do |organization_login|
      begin
        teams << octokit_client.organization_teams(organization_login)
      rescue Octokit::Error
        # Do nothing, intentional.
      end
    end
    teams.flatten.map(&:to_attrs)
  end
end
