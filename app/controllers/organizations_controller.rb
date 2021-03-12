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
    set_corrmat
    @color_scores = get_color_scores
    github_user
    @belonged_team = @team_members_ids.nil? ? false : @team_members_ids.include?(github_user.gh_id)
    @inactive_days = get_members_inactive_days
  end

  def create
    CreateOrganization.for(token: @github_session.token, github_organization: @github_organization)
    redirect_to settings_organization_path(name: @github_organization[:login])
  end

  def missing; end

  def settings
    @is_admin_github_session = github_session.session[:client_type] == "admin"
    if @has_dashboard && @organization.default_team_id.present?
      load_behaviour_matrix_params
      if @default_team_members_ids
        set_behaviour_matrix
      end
    end
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


  def load_matrix_params
    @teams = froggo_teams
    if permitted_params[:team]
      if permitted_params[:froggo_team] == "true"
        @team = FroggoTeam.find_by(name: permitted_params[:team])
        @team_members_ids = @team.github_users&.pluck(:gh_id)
      else
        @team = @teams.find { |team| team[:slug] == permitted_params[:team] }
        @team_members_ids = github_team_members&.pluck(:id)
      end
    end
    if permitted_params[:month_limit].present?
      @month_limit = permitted_params[:month_limit].to_i
    end
  end

  def load_behaviour_matrix_params
    @teams = froggo_teams
    if @organization.default_team_id
      @team = @teams.find { |team| team[:id] == @organization.default_team_id }
      if @team[:froggo_team]
        @team = FroggoTeam.find(@organization.default_team_id)
        @default_team_members_ids = @team.github_users&.pluck(:gh_id)
      else
        @default_team_members_ids = github_team_members&.pluck(:id)
      end
    end
  end

  def set_corrmat
    if @has_dashboard
      @corrmat = get_matrix(@organization.id, @team_members_ids, @month_limit)
    end
  end

  def get_matrix(org_id, user_ids, month_limit)
    corrmat = CorrelationMatrix.new(org_id, user_ids, github_user.login, month_limit)
    corrmat.fill_matrix
    corrmat.min_ranking_indexes
    corrmat
  end

  def set_behaviour_matrix
    @behaviour_matrix = get_behaviour_matrix(@organization.id, @default_team_members_ids)
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

  def get_behaviour_matrix(organization_id, default_team_members_ids)
    behaviour_matrix = RecommendationBehaviourMatrix.new(organization_id, default_team_members_ids)
    behaviour_matrix.fill_matrix
    behaviour_matrix
  end

  def save_cookie_url
    github_session.save_froggo_path(request.fullpath)
  end

  def get_color_scores
    return unless @has_dashboard

    ComputeColorScore.for(
      user_id: github_user.id, team_users_ids: get_other_users_ids,
      pr_relations: get_pr_relations, review_month_limit: @month_limit,
      team_id: get_team_id
    )
  end

  def get_other_users_ids
    return GithubUser.where(gh_id: @team_members_ids).pluck(:id) if @team_members_ids

    @organization.members.pluck(:id)
  end

  def get_pr_relations
    return PullRequestRelation.by_organizations(@organization.id) unless @month_limit

    PullRequestRelation.by_organizations(@organization.id).within_month_limit(@month_limit)
  end

  def get_team_id
    permitted_params[:froggo_team] == "true" ? @team&.id : nil
  end

  def get_members_inactive_days
    return unless @team

    inactive_days = {}
    period_start = Time.current - month_limit.month
    @team.github_users.each do |user|
      membership = FroggoTeamMembership.find_by(github_user: user, froggo_team: @team)
      inactive_days[user.id] = get_inactive_days(membership, period_start)
    end
    inactive_days
  end

  def get_inactive_days(membership, period_start)
    if membership.last_activation_date.nil? || membership.last_activation_date < period_start
      return 0
    end

    days_off = if membership.last_deactivation_date > period_start
                 membership.last_activation_date.to_date - membership.last_deactivation_date.to_date
               else
                 membership.last_activation_date.to_date - period_start.to_date
               end
    days_off.to_i
  end
end
