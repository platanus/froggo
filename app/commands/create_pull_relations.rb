class CreatePullRelations < PowerTypes::Command.new(:pull_request)
  def perform
    creates_from_merge_info
    creates_from_reviews
  end

  private

  def creates_from_merge_info
    if @pull_request.merged_by.present? &&
        PullRequestRelation.by_pull_request(@pull_request.id).merged_relations.empty?
      PullRequestRelation.merged_relations.create!(
        pull_request: @pull_request,
        github_user: @pull_request.merged_by,
        organization_id: @pull_request.repository.organization_id,
        gh_updated_at: @pull_request,
        target_user_id: @pull_request.owner_id
      )
    end
  end

  def creates_from_reviews
    if @pull_request.pull_request_reviews.present?
      PullRequestRelation.by_pull_request(@pull_request.id).destroy_all
      last_review_for_each_user.each do |review|
        PullRequestRelation.review_relations.create!(
          pull_request: @pull_request,
          github_user_id: review.github_user_id,
          organization_id: @pull_request.repository.organization_id,
          gh_updated_at: review.updated_at,
          target_user_id: @pull_request.owner_id
        )
      end
    end
  end

  def last_review_for_each_user
    reviews_by_users = @pull_request.pull_request_reviews.group_by(&:github_user_id)
    reviews_by_users.map { |_, r| r.max_by(&:updated_at) }
  end
end
