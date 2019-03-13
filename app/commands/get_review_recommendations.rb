class GetReviewRecommendations < PowerTypes::Command.new(:github_user_id, :other_users_ids)
  def perform
    sorted_map =
      map_user_id_to_times_reviewed
      .sort_by { |_, times_reviewed| times_reviewed }
    {
      best: sorted_map.first(3).map { |user_id, _| GithubUser.find(user_id) },
      worst: sorted_map.last(3).map { |user_id, _| GithubUser.find(user_id) }
    }
  end

  private

  def map_user_id_to_times_reviewed
    appearance_counter =
      PullRequestRelation
      .review_relations
      .within_month_limit(1)
      .where(github_user_id: @github_user_id, target_user_id: @other_users_ids)
      .pluck(:target_user_id)
      .each_with_object(Hash.new(0)) { |user_id, counter| counter[user_id] += 1 }
    # up to this point, `appearance_counter` doesn't include users that
    # have never reviewed `@github_user_id`.
    @other_users_ids.each do |other_user_id|
      unless appearance_counter.key? other_user_id
        appearance_counter[other_user_id] = 0
      end
    end
    appearance_counter
  end
end
