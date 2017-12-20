class RepositoryObserver < PowerTypes::Observer
  after_save :update_entities

  def update_entities
    if object.saved_change_to_tracked?
      if object.tracked
        HookService.new.subscribe(object)
        GithubWorker.perform_async('FETCH_REPOS_PULL_REQUEST',
          owner_id: object.organization.owner_id, repository_id: object.id)
      elsif !object.saved_change_to_id?
        Untrack.for(repo: object)
      end
    end
  end
end
