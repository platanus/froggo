class GithubAuthController < ApplicationController
  def oauth_request
    session[:access_token] = nil
  end

  def authenticate!
    redirect_to GetGithubAuthUrl.for(callback_action: :login, client_type: :member)
  end

  def callback
    set_session_gh_access

    redirect_to '/'
  end

  private

  def permitted_params
    params.permit(:client_type, :callback_action, :gh_org)
  end

  def set_session_gh_access
    session_code = request.query_parameters['code']
    result = Octokit.exchange_code_for_token(session_code, ENV['GH_AUTH_ID'], ENV['GH_AUTH_SECRET'])
    session[:access_token] = result[:access_token]
    session[:client_type] = permitted_params[:client_type]
  end
end
