class GithubAuthController < ApplicationController
  def oauth_request
    session[:access_token] = nil
  end

  def authenticate!
    redirect_to OctokitClient.auth_client_url
  end

  def callback
    session_code = request.query_parameters['code']
    result = OctokitClient.exchange_code_for_token(session_code)
    session[:access_token] = result[:access_token]
    redirect_to '/'
  end
end
