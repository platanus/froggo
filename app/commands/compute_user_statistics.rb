class ComputeUserStatistics < PowerTypes::Command.new(:github_user_id, :organization_id)
  REVIEW_MONTH_LIMIT = 1

  def perform
    {
      obedient: times_obedient,
      indifferent: times_indifferent,
      rebel: times_rebel,
      not_defined: times_not_defined
    }
  end

  private

  def times_obedient
    PullRequestRelation
      .review_relations
      .obedient_behaviour
      .within_month_limit(REVIEW_MONTH_LIMIT)
      .where(target_user_id: @github_user_id, organization_id: @organization_id)
      .count
  end

  def times_indifferent
    PullRequestRelation
      .review_relations
      .indifferent_behaviour
      .within_month_limit(REVIEW_MONTH_LIMIT)
      .where(target_user_id: @github_user_id, organization_id: @organization_id)
      .count
  end

  def times_rebel
    PullRequestRelation
      .review_relations
      .rebel_behaviour
      .within_month_limit(REVIEW_MONTH_LIMIT)
      .where(target_user_id: @github_user_id, organization_id: @organization_id)
      .count
  end

  def times_not_defined
    PullRequestRelation
      .review_relations
      .not_defined_behaviour
      .within_month_limit(REVIEW_MONTH_LIMIT)
      .where(target_user_id: @github_user_id, organization_id: @organization_id)
      .count
  end
end
