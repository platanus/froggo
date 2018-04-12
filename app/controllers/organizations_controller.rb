class OrganizationsController < ApplicationController
  before_action :authenticate_github_user
  before_action :load_organization, except: [:index, :missing]
  before_action :ensure_organization_admin, only: :settings

  def index
    if github_organizations.empty?
      redirect_to missing_organizations_path
    else
      redirect_to_default_organization
    end
  end

  def show
    @is_admin = organization_admin?
    @organizations = github_organizations.map { |org| org[:login] }
    @corrmat = get_matrix(@organization.id) if @has_dashboard
  end

  def create
    if @organization.nil?
      organization = Organization.create!(
        gh_id: @github_organization[:id],
        login: @github_organization[:login]
      )

      OrganizationSyncJob.perform_later(OrganizationSync.create!(organization: organization),
        @github_session.token)
    end

    redirect_to settings_organization_path(name: @github_organization[:login])
  end

  def missing; end

  def settings
    @is_admin_github_session = github_session.session[:client_type] == "admin"
  end

  private

  def load_organization
    @github_organization = github_organizations.find do |org|
      org[:login] == permitted_params[:name]
    end

    if @github_organization.nil?
      redirect_to '/organizations'
    else
      @organization = Organization.find_by(gh_id: @github_organization[:id])
      @has_dashboard = !@organization.nil?
    end
  end

  def redirect_to_default_organization
    redirect_to organization_path(name: github_session.organizations.first[:login])
  end

  def github_organizations
    github_session.organizations
  end

  def ensure_organization_admin
    redirect_to organization_path(name: @github_organization[:login]) unless organization_admin?
  end

  def organization_admin?
    @github_organization[:role] == "admin"
  end

  def permitted_params
    params.permit(:name)
  end

  def get_matrix(org_id)
    corrmat = CorrelationMatrix.new(org_id)
    corrmat.fill_matrix
    corrmat
  end
end
