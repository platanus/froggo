class GetReviewRecommendations < PowerTypes::Command.new(:github_user_id, :other_users_ids,
                                                         month_limit: nil, froggo_team_id: nil)
  NUMBER_OF_RECOMMENDATIONS = 3

  def perform
    {
      best: best_recommendations(other_users_with_score, number_of_best_recommendations),
      worst: worst_recommendations(other_users_with_score, number_of_worst_recommendations),
      all: other_users_with_score
    }
  end

  private

  def color_scores
    @color_scores ||= begin
      pr_relations = PullRequestRelation.review_relations
      ComputeColorScore.for(user_id: @github_user_id, team_users_ids: @other_users_ids,
                            pr_relations: pr_relations, review_month_limit: @month_limit,
                            team_id: @froggo_team_id)
    end
  end

  def best_recommendations(sorted_map, number_of_recommendations)
    sorted_map.first(number_of_recommendations)
  end

  def worst_recommendations(sorted_map, number_of_recommendations)
    sorted_map.last(number_of_recommendations).reverse
  end

  def other_users_with_score
    @other_users_with_score ||= GithubUser.where(id: @other_users_ids).map do |user|
                                  user.as_json.with_indifferent_access.merge(
                                    score: color_scores[user.id],
                                    tags: user.tags.as_json
                                  )

                                end.sort_by { |user| user[:score] }
  end

  def number_of_best_recommendations
    @number_of_best_recommendations ||= begin
      num_of_users = @other_users_ids.length
      return NUMBER_OF_RECOMMENDATIONS if num_of_users > NUMBER_OF_RECOMMENDATIONS

      [num_of_users - 1, 0].max
    end
  end

  def number_of_worst_recommendations
    num_of_users = @other_users_ids.length
    [NUMBER_OF_RECOMMENDATIONS, num_of_users - number_of_best_recommendations].min
  end
end
