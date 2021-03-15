class OrganizationsController < ApplicationController
  before_action :authenticate_github_user
  before_action :save_cookie_url
  before_action :load_organization, except: [:index, :missing]
  before_action :ensure_organization_admin, only: :settings

  MONTH_LIMIT_DEFAULT = 9

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
    github_user
    @belonged_team = @team_members_ids.nil? ? false : @team_members_ids.include?(github_user.gh_id)
  end

  def create
    CreateOrganization.for(token: @github_session.token, github_organization: @github_organization)
    redirect_to settings_organization_path(name: @github_organization[:login])
  end

  def missing; end

  def settings
    @is_admin_github_session = github_session.session[:client_type] == "admin"
    @teams = froggo_teams
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
    end
  end

  def month_limit
    @month_limit ||= MONTH_LIMIT_DEFAULT
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
    github_session.get_team_members(@team[:id])
  end

  def froggo_teams
    @organization.get_froggo_teams
  end

  def user_teams
    gh_teams = github_teams
    gh_teams.each do |team|
      team[:froggo_team] = false
    end
    gh_teams.concat(froggo_teams)
            .sort_by { |team| team[:name].downcase }
  end

  def ensure_organization_admin
    redirect_to organization_path(name: @github_organization[:login]) unless organization_admin?
  end

  def organization_admin?
    @github_organization[:role] == "admin"
  end

  def permitted_params
    params.permit(:name, :team, :month_limit, :froggo_team, user_ids: [])
  end

  def save_cookie_url
    github_session.save_froggo_path(request.fullpath)
  end
end
