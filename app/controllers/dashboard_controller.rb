class DashboardController < ApplicationController
  before_action :ensure_gh_session
  before_action :set_user_organizations, except: :missing_organizations
  before_action :ensure_organization, except: :missing_organizations
  before_action :ensure_organization_admin, only: :settings

  def index
    @has_dashboard = Organization.exists?(gh_id: @organization[:id])
    @corrmat = get_matrix(@organization[:id]) if @has_dashboard
    @auth_login = get_ghuser
  end

  def create; end

  def missing_organizations; end

  def settings; end

  private

  def ensure_gh_session
    redirect_to '/oauth' unless session[:access_token]
  end

  def ensure_organization
    if @user_organizations.empty?
      redirect_to dashboard_missing_organizations_path
    elsif permitted_params[:gh_org].blank?
      redirect_to dashboard_path(gh_org: @user_organizations.first[:login])
    else
      @organization = select_orga_data(permitted_params[:gh_org])
      redirect_to dashboard_path(gh_org: @user_organizations.first[:login]) if @organization.nil?
    end
  end

  def ensure_organization_admin
    if @organization[:role] != 'admin'
      redirect_to dashboard_path(gh_org: @organization[:login])
    end
  end

  def permitted_params
    params.permit(:gh_org)
  end

  def set_user_organizations
    set_organizations_cookie if cookies['orgs'].nil?
    @user_organizations = JSON.parse(cookies['orgs']).map { |elem| elem.transform_keys(&:to_sym) }
  end

  def set_organizations_cookie
    orgs = service.organization_memberships
    cookies['orgs'] = JSON.generate(orgs)
  end

  def get_ghuser
    if cookies['ghuser'].nil?
      cookies['ghuser'] = service.user['login']
    end
    cookies['ghuser']
  end

  def get_matrix(gh_org)
    corrmat = CorrelationMatrix.new(gh_org)
    corrmat.fill_matrix
    corrmat
  end

  def select_orga_data(gh_org)
    @user_organizations.find { |orga| orga[:login] == gh_org }
  end

  def service
    @service = GithubService.new(user_token: session[:access_token])
  end
end
