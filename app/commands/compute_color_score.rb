class ComputeColorScore < PowerTypes::Command.new(:user_id, :other_users_ids, :pr_relations)
  def perform
    scores = {}
    @other_users_ids.each do |other_user_id|
      scores[other_user_id] = score_for_other_user(other_user_id)
    end
    scores
  end

  private

  def score_for_other_user(other_user_id)
    return -1 if mean_prs_sent.zero?

    (reviews_per_user[other_user_id] || 0).to_f / mean_prs_sent
  end

  def mean_prs_sent
    @mean_prs_sent ||= compute_mean_prs_sent
  end

  def compute_mean_prs_sent
    reviews_per_user.empty? ? 0.0 : reviews_per_user.values.sum.to_f / reviews_per_user.length
  end

  def reviews_per_user
    @reviews_per_user ||= @pr_relations.where(target_user_id: @user_id)
                                       .where(github_user_id: @other_users_ids)
                                       .group(:github_user_id)
                                       .count
  end
end
