class ComputeColorScore < PowerTypes::Command.new(:user_id, :team_users_ids, :pr_relations,
                                                  review_month_limit: nil, team_id: nil)
  REVIEW_MONTH_LIMIT_DEFAULT = 9

  def perform
    scores = {}
    @team_users_ids.each do |other_user_id|
      next if @user_id == other_user_id

      scores[other_user_id] = score_for_other_user(other_user_id)
    end
    scores
  end

  private

  def review_month_limit
    @review_month_limit ||= REVIEW_MONTH_LIMIT_DEFAULT
  end

  def score_for_other_user(other_user_id)
    return -1 if mean_prs_sent.zero?

    return (reviews_per_user[other_user_id] || 0).to_f / mean_prs_sent if @team_id.nil?

    user_active_days = active_days[other_user_id]
    user_pr_rate = pull_request_rate(other_user_id)
    (reviews_per_user[other_user_id] || 0).to_f / (mean_prs_sent * user_active_days * user_pr_rate)
  end

  def mean_prs_sent
    @mean_prs_sent ||= compute_mean_prs_sent
  end

  def period_start
    @period_start ||= Time.current - review_month_limit.month
  end

  def period_days
    @period_days ||= Time.current.to_date - period_start.to_date
  end

  def organization_id
    @organization_id ||= if @team_id
                           FroggoTeam.find(@team_id).organization_id
                         end
  end

  def compute_mean_prs_sent
    other_users_ids = @team_users_ids - [@user_id]
    if @team_id
      other_users_ids.empty? ? 0.0 : daily_reviews_per_user.values.sum.to_f / other_users_ids.length
    else
      other_users_ids.empty? ? 0.0 : reviews_per_user.values.sum.to_f / other_users_ids.length
    end
  end

  def reviews_per_user
    @reviews_per_user ||= @pr_relations.within_month_limit(review_month_limit)
                                       .where(target_user_id: @user_id)
                                       .where(github_user_id: @team_users_ids)
                                       .where.not(github_user_id: @user_id)
                                       .group(:github_user_id)
                                       .count
  end

  def daily_reviews_per_user
    @daily_reviews_per_user ||= reviews_per_user.map { |id, pr| [id, (pr / active_days[id].to_f)] }
                                                .to_h
  end

  def active_days
    @active_days ||= users_active_days
  end

  def users_active_days
    active_days = {}
    @team_users_ids.each do |user_id|
      next if @user_id == user_id

      active_days[user_id] = get_active_time(user_id).to_i
    end
    active_days
  end

  def get_active_time(user_id)
    org_membership = OrganizationMembership.find_by(github_user_id: user_id,
                                                    organization_id: organization_id)
    team_membership = FroggoTeamMembership.find_by(github_user_id: user_id,
                                                   froggo_team_id: @team_id)
    membership_time(org_membership) - inactivity_time(team_membership)
  end

  def membership_time(membership)
    days_being_member = Time.current.to_date - membership.created_at.to_date
    if days_being_member > period_days
      return period_days

    elsif days_being_member.zero?
      return 1
    end

    days_being_member
  end

  def inactivity_time(membership)
    if membership.last_activation_date.nil? || membership.last_activation_date < period_start
      return 0
    end

    days_off = if membership.last_deactivation_date > period_start
                 membership.last_activation_date.to_date - membership.last_deactivation_date.to_date
               else
                 membership.last_activation_date.to_date - period_start.to_date
               end
    days_off
  end

  def pull_request_rate(user_id)
    membership = FroggoTeamMembership.find_by(github_user_id: user_id,
                                              froggo_team_id: @team_id)
    membership.assignment_percentage.to_f / 100
  end
end
