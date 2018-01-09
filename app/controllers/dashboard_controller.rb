class DashboardController < ApplicationController
  before_action :ensure_gh_session
  before_action :set_user_organizations
  before_action :set_organization

  def index
    users = GithubUser.where(tracked: true)
    @corrmat = get_matrix(users)
    @auth_login = get_ghuser
  end

  private

  def ensure_gh_session
    redirect_to '/oauth' unless session[:access_token]
  end

  def set_organization
    if params[:gh_org].blank?
      redirect_to '/dashboard/' + @user_organizations.first
    else
      @organization = params[:gh_org]
    end
  end

  def set_user_organizations
    set_organizations_cookie if cookies['orgs'].nil?
    @user_organizations = cookies['orgs'].split('&')
  end

  def set_organizations_cookie
    orgs = OctokitClient.fetch_organization_memberships(session[:access_token])
    orgs.map! { |o| o[:login] }
    cookies['orgs'] = orgs.join('&')
  end

  def get_ghuser
    if cookies['ghuser'].nil?
      client = Octokit::Client.new(access_token: session[:access_token])
      cookies['ghuser'] = client.user['login']
    end
    cookies['ghuser']
  end

  def get_matrix(users)
    corrmat = CorrelationMatrix.new(users)
    corrmat.fill_matrix
    corrmat
  end
end
