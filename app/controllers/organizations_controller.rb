class OrganizationsController < ApplicationController
  before_action :authenticate_github_user
  before_action :ensure_organization, except: :missing_organizations
  before_action :ensure_organization_admin, only: :settings

  def index
    @has_dashboard = Organization.exists?(gh_id: organization[:id])
    @is_admin = organization_admin?
    # @corrmat = get_matrix(@organization[:id]) if @has_dashboard
    # @auth_login = get_ghuser
  end

  def create; end

  def missing; end

  def settings; end

  private

  def ensure_organization
    if github_organizations.empty?
      redirect_to missing_organizations_path
    elsif permitted_params[:name].blank? || organization.nil?
      redirect_to default_organization_path
    end
  end

  def default_organization_path
    organization_path(name: github_session.organizations.first[:login])
  end

  def github_organizations
    github_session.organizations
  end

  def organization
    @organization ||= github_organizations.find { |org| org[:login] == permitted_params[:name] }
  end

  def ensure_organization_admin
    redirect_to organization_path(name: @organization[:login]) unless organization_admin?
  end

  def organization_admin?
    organization[:role] == "admin"
  end

  def permitted_params
    params.permit(:name)
  end

  # def get_ghuser
  #   if cookies['ghuser'].nil?
  #     cookies['ghuser'] = service.user['login']
  #   end
  #   cookies['ghuser']
  # end

  # def get_matrix(name)
  #   corrmat = CorrelationMatrix.new(name)
  #   corrmat.fill_matrix
  #   corrmat
  # end

  def select_orga_data(name)
    github_session.organizations.find { |orga| orga[:login] == name }
  end
end
