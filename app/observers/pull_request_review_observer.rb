class PullRequestReviewObserver < PowerTypes::Observer
  after_save :update_pull_request_relations

  def update_pull_request_relations
    service = PullRequestRelationService.new(pull_request: object.pull_request)
    service.create_review_relations
  end
end
