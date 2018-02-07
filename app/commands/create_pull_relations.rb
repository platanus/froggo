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
        github_user: @pull_request.merged_by
      )
    end
  end

  def creates_from_reviews
    if @pull_request.pull_request_reviews.present?
      gh_user_ids_for_new_relations.each do |reviewer_id|
        PullRequestRelation.review_relations.create!(
          pull_request: @pull_request,
          github_user_id: reviewer_id
        )
      end
    end
  end

  def gh_user_ids_for_new_relations
    reviewer_ids = @pull_request.pull_request_reviewers.pluck(:github_user_id).uniq
    relation_reviewers_ids = PullRequestRelation.review_relations.by_pull_request(@pull_request.id)
                                                .pluck(:github_user_id).uniq
    reviewer_ids - relation_reviewers_ids
  end
end
