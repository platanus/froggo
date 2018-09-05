class GithubAuthController < ApplicationController
  def oauth_request
    github_session.clean_session
    redirect_to root_path
  end

  def authenticate!
    redirect_to GetGithubAuthUrl.for(callback_action: :login, client_type: :member)
  end

  def admin_authenticate!
    redirect_to GetGithubAuthUrl.for(callback_action: :settings, client_type: :admin,
                                     callback_params: { gh_org: permitted_params[:gh_org] })
  end

  def callback
    set_session_gh_access
    if permitted_params[:callback_action] == 'settings'
      redirect_to settings_organization_path(name: permitted_params[:gh_org])
    else
      redirect_to github_session.froggo_path || organizations_path
    end
  end

  private

  def permitted_params
    params.permit(:client_type, :callback_action, :gh_org)
  end

  def set_session_gh_access
    session_code = request.query_parameters['code']
    result = Octokit.exchange_code_for_token(session_code, ENV['GH_AUTH_ID'], ENV['GH_AUTH_SECRET'])
    github_session.set_session(result[:access_token], permitted_params[:client_type])
  end
end
