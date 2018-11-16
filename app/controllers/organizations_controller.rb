class OrganizationsController < ApplicationController
  before_action :authenticate_github_user, except: [:public]
  before_action :save_cookie_url
  before_action :load_organization, except: [:index, :missing, :public]
  before_action :load_organization_by_name, only: [:public]
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
    @organizations = github_organizations
    set_corrmat
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

  def public
    set_corrmat
    @public_mode = true
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
      load_matrix_params if @has_dashboard
    end
  end

  def load_organization_by_name
    @organization = Organization.find_by(login: permitted_params[:name])
    @has_dashboard = !@organization.nil?
  end

  def load_matrix_params
    @teams = github_teams
    if permitted_params[:team]
      @team = @teams.find { |team| team[:slug] == permitted_params[:team] }
      @team_members = github_team_members
    end
    if permitted_params[:month_limit].present?
      @month_limit = permitted_params[:month_limit].to_i
    end
  end

  def set_corrmat
    if @has_dashboard
      @corrmat = get_matrix(@organization.id, @team_members&.pluck(:id), @month_limit)
    end
  end

  def redirect_to_default_organization
    redirect_to organization_path(name: github_session.organizations.first[:login])
  end

  def github_organizations
    github_session.organizations
  end

  def github_teams
    github_session.get_teams(@organization)
  end

  def github_team_members
    github_session.get_team_members(@team)
  end

  def ensure_organization_admin
    redirect_to organization_path(name: @github_organization[:login]) unless organization_admin?
  end

  def organization_admin?
    @github_organization[:role] == "admin"
  end

  def permitted_params
    params.permit(:name, :team, :month_limit)
  end

  def get_matrix(org_id, user_ids, month_limit)
    corrmat = CorrelationMatrix.new(org_id, user_ids, month_limit)
    corrmat.fill_matrix
    corrmat
  end

  def save_cookie_url
    github_session.save_froggo_path(request.fullpath)
  end
end
