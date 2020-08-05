class ComputeColorScore < PowerTypes::Command.new(:user_id, :team_users_ids, :pr_relations,
                                                  review_month_limit: nil)
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

    (reviews_per_user[other_user_id] || 0).to_f / mean_prs_sent
  end

  def mean_prs_sent
    @mean_prs_sent ||= compute_mean_prs_sent
  end

  def compute_mean_prs_sent
    reviews_per_user.empty? ? 0.0 : reviews_per_user.values.sum.to_f / @team_users_ids.length
  end

  def reviews_per_user
    @reviews_per_user ||= @pr_relations.within_month_limit(review_month_limit)
                                       .where(target_user_id: @user_id)
                                       .where(github_user_id: @team_users_ids)
                                       .where.not(github_user_id: @user_id)
                                       .group(:github_user_id)
                                       .count
  end
end
