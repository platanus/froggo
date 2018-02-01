class DashboardController < ApplicationController
  before_action :authenticate_github_user
  before_action :ensure_organization, except: :missing_organizations
  before_action :ensure_organization_admin, only: :settings

  def index
    @has_dashboard = Organization.exists?(gh_id: organization[:id])
    # @corrmat = get_matrix(@organization[:id]) if @has_dashboard
    # @auth_login = get_ghuser
  end

  def create; end

  def missing_organizations; end

  def settings; end

  private

  def ensure_organization
    if github_organizations.empty?
      redirect_to dashboard_missing_organizations_path
    elsif permitted_params[:gh_org].blank? || organization.nil?
      redirect_to default_dashboard_path
    end
  end

  def default_dashboard_path
    dashboard_path(gh_org: github_session.organizations.first[:login])
  end

  def github_organizations
    github_session.organizations
  end

  def organization
    @organization ||= github_organizations.find { |org| org[:login] == permitted_params[:gh_org] }
  end

  def ensure_organization_admin
    redirect_to dashboard_path(gh_org: @organization[:login]) unless organization_admin?
  end

  def organization_admin?
    organization[:role] == "admin"
  end

  def permitted_params
    params.permit(:gh_org)
  end

  # def get_ghuser
  #   if cookies['ghuser'].nil?
  #     cookies['ghuser'] = service.user['login']
  #   end
  #   cookies['ghuser']
  # end

  # def get_matrix(gh_org)
  #   corrmat = CorrelationMatrix.new(gh_org)
  #   corrmat.fill_matrix
  #   corrmat
  # end

  def select_orga_data(gh_org)
    github_session.organizations.find { |orga| orga[:login] == gh_org }
  end
end
