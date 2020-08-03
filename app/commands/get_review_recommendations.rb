class GetReviewRecommendations < PowerTypes::Command.new(:github_user_id, :other_users_ids)
  NUMBER_OF_RECOMMENDATIONS = 3

  def perform
    users_with_score = other_users_with_score
    {
      best: best_recommendations(users_with_score, NUMBER_OF_RECOMMENDATIONS),
      worst: worst_recommendations(users_with_score, NUMBER_OF_RECOMMENDATIONS),
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
end
