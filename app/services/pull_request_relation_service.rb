class PullRequestRelationService < PowerTypes::Service.new(:pull_request)
  def create_merge_relation
    if @pull_request.merged_by.present?
      PullRequestRelation.merged_relations.by_pull_request(@pull_request.id).destroy_all
      PullRequestRelation.merged_relations.create!(
        pull_request: @pull_request,
        github_user: @pull_request.merged_by,
        organization_id: @pull_request.repository.organization_id,
        gh_updated_at: @pull_request,
        target_user_id: @pull_request.owner_id
      )
    end
  end

  def create_review_relations
    if @pull_request.pull_request_reviews.present?
      PullRequestRelation.review_relations.by_pull_request(@pull_request.id).destroy_all
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

  private

  def last_review_for_each_user
    reviews_by_users = @pull_request.pull_request_reviews.group_by(&:github_user_id)
    reviews_by_users.map { |_, r| r.max_by(&:updated_at) }
  end
end
