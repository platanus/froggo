class DashboardController < ApplicationController
  def index
    if authenticated?
      @corrmat = CorrelationMatrix.new(GithubUser.where(tracked: true))
      @corrmat.fill_matrix
      @auth_login = session[:data][0][1]
    else
      redirect_to '/oauth'
    end
  end

  def oauth_request
    # authenticate view
  end

  def get_user_data
    client = Octokit::Client.new access_token: session[:access_token]
    client.user
  end

  def authenticated?
    session[:access_token]
  end

  def authenticate!
    client = Octokit::Client.new
    url = client.authorize_url(ENV['GH_AUTH_ID'], scope: 'user,read:org')
    redirect_to url
  end

  def callback
    session_code = request.query_parameters['code']
    result = Octokit.exchange_code_for_token(session_code, ENV['GH_AUTH_ID'], ENV['GH_AUTH_SECRET'])
    session[:access_token] = result[:access_token]
    session[:data] = get_user_data
    redirect_to '/'
  end
end
