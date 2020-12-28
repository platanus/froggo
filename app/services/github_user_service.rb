class GithubUserService < PowerTypes::Service.new
  def find_or_create(github_user_params)
    found = GithubUser.create_with(
      login: github_user_params.login,
      avatar_url: github_user_params.avatar_url,
      html_url: github_user_params.html_url,
      email: github_user_params.email,
      name: github_user_params.name,
      description: github_user_params.description
    ).find_or_create_by!(gh_id: github_user_params.id)
    found.update!(name: github_user_params.name) if found.name.nil?
    found
  end
end
