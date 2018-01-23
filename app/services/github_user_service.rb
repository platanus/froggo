class GithubUserService < PowerTypes::Service.new
  def find_or_create(github_user_params)
    GithubUser.create_with(
      login: github_user_params[:login],
      avatar_url: github_user_params[:avatar_url],
      html_url: github_user_params[:html_url],
      email: github_user_params[:email],
      name: github_user_params[:name]
    ).find_or_create_by!(gh_id: github_user_params[:gh_id])
  end
end
