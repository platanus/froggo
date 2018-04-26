class PullRequestObserver < PowerTypes::Observer
  after_save :update_pull_request_relations
  before_destroy :destroy_pull_request_relations

  def update_pull_request_relations
    if object.saved_change_to_merged_by_id?
      service = PullRequestRelationService.new(pull_request: object)
      service.create_merge_relation
    end
  end

  def destroy_pull_request_relations
    PullRequestRelation.by_pull_request(object.id).destroy_all
  end
end
