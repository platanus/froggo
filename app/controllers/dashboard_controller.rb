class DashboardController < ApplicationController
  def authenticated?
    session[:access_token]
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

  def index
    if authenticated?
      @user_orgs = selector
      if request.query_parameters['org'].nil?
        redirect_to '?org=' + @user_orgs.first[1]
      else
        @current_org = request.query_parameters['org']
        @corrmat = get_matrix(@current_org)
        @auth_login = get_ghuser
      end
    else
      redirect_to '/oauth'
    end
  end

  def get_ghuser
    if cookies['ghuser'].nil?
      client = Octokit::Client.new(access_token: session[:access_token])
      cookies['ghuser'] = client.user['login']
    end
    cookies['ghuser']
  end

  def get_matrix(organization)
    corrmat = CorrelationMatrix.new(organization)
    corrmat.fill_matrix
    corrmat
  end

  def get_orgs
    orgs = OctokitClient.fetch_organization_memberships(session[:access_token])
    orgs = orgs.map { |o| o[:login] }
    cookies['orgs'] = orgs
    orgs
  end

  def map_orgs
    orgs = cookies['orgs'].split('&')
    orgs = orgs.map { |o| [o, o] }
    orgs
  end

  def oauth_request
    session[:access_token] = nil
  end

  def selector
    if cookies['orgs'].nil?
      get_orgs
    end
    map_orgs
  end
end
