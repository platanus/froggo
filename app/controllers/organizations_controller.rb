class OrganizationsController < ApplicationController
  before_action :authenticate_github_user
  before_action :load_organization, except: [:index, :missing_organizations]
  before_action :ensure_organization_admin, only: :settings

  def index
    if github_organizations.empty?
      redirect_to missing_organizations_path
    else
      redirect_to_default_organization
    end
  end

  def show
    @has_dashboard = Organization.exists?(gh_id: @organization[:id])
    @is_admin = organization_admin?
    @organizations = github_organizations.map { |org| org[:login] }
    # @corrmat = get_matrix(@organization[:id]) if @has_dashboard
  end

  def create; end

  def missing; end

  def settings
    @is_admin_github_session = github_session.session[:client_type] == "admin"
  end

  private

  def load_organization
    @organization = github_organizations.find { |org| org[:login] == permitted_params[:name] }
    redirect_to '/organizations' if @organization.nil?
  end

  def redirect_to_default_organization
    redirect_to organization_path(name: github_session.organizations.first[:login])
  end

  def github_organizations
    github_session.organizations
  end

  def ensure_organization_admin
    redirect_to organization_path(name: @organization[:login]) unless organization_admin?
  end

  def organization_admin?
    @organization[:role] == "admin"
  end

  def permitted_params
    params.permit(:name)
  end

  # def get_matrix(name)
  #   corrmat = CorrelationMatrix.new(name)
  #   corrmat.fill_matrix
  #   corrmat
  # end
end
