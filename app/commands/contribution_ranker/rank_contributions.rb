class ContributionRanker::RankContributions <
  PowerTypes::Command.new(:users_contributions, :limit)
  def perform
    validate_users_contributions! @users_contributions
    rank(with_self_contributions_first(@users_contributions)).first(@limit)
  end

  private

  def rank(sorted_users_contributions)
    sorted_users_contributions
      .sort_by do |_, all_reviewed_prs|
        ContributionRanker::ComputeScore.for(
          self_reviewed_prs: all_reviewed_prs.first,
          per_user_reviews: all_reviewed_prs.drop(1)
        )
      end
      .reverse
      .map(&:first)
  end

  def validate_users_contributions!(users_contributions)
    amount_of_users = infer_amount_of_users users_contributions
    (0...amount_of_users).each do |i|
      (0...amount_of_users).each do |j|
        raise(ArgumentError, "Data not found at (#{i}, #{j})") \
          unless users_contributions[[i, j]]
      end
    end
  end

  def infer_amount_of_users(users_contributions)
    max_index = -1
    users_contributions.keys.each do |x_and_y|
      max_index = [max_index, x_and_y.max].max
    end
    max_index + 1
  end

  def with_self_contributions_first(users_contributions)
    sorted_users_contributions = {}
    amount_of_users = infer_amount_of_users users_contributions
    (0...amount_of_users).each do |x|
      sorted_users_contributions[x] = [users_contributions[[x, x]]]
      (0...amount_of_users).each do |y|
        sorted_users_contributions[x] << users_contributions[[x, y]] if x != y
      end
    end
    sorted_users_contributions
  end
end
