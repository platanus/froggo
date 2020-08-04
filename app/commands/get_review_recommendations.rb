class GetReviewRecommendations < PowerTypes::Command.new(:github_user_id, :other_users_ids)
  NUMBER_OF_RECOMMENDATIONS = 3

  def perform
    users_with_score = other_users_with_score
    {
      best: best_recommendations(users_with_score, number_of_best_recommendations),
      worst: worst_recommendations(users_with_score, number_of_worst_recommendations),
      all: users_with_score
    }
  end

  private

  def color_scores
    pr_relations = PullRequestRelation.review_relations
    ComputeColorScore.for(user_id: @github_user_id, other_users_ids: @other_users_ids,
                          pr_relations: pr_relations)
  end

  def best_recommendations(sorted_map, number_of_recommendations)
    sorted_map.first(number_of_recommendations).map { |_, user| user }
  end

  def worst_recommendations(sorted_map, number_of_recommendations)
    sorted_map.last(number_of_recommendations).map { |_, user| user }.reverse
  end

  def other_users_with_score
    scores = color_scores
    result = {}
    GithubUser.where(id: @other_users_ids).map do |user|
      result[user.id] = user.as_json.merge(score: scores[user.id])
    end
    result.sort_by { |_, user| user[:score] }
  end

  def number_of_best_recommendations
    num_of_users = @other_users_ids.length
    return NUMBER_OF_RECOMMENDATIONS if num_of_users > NUMBER_OF_RECOMMENDATIONS

    [num_of_users - 1, 1].max
  end

  def number_of_worst_recommendations
    num_of_users = @other_users_ids.length
    [NUMBER_OF_RECOMMENDATIONS, [0, num_of_users - number_of_best_recommendations].max].min
  end
end
