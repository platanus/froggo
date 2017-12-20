class OrganizationObserver < PowerTypes::Observer
  after_save :create_organization_repositories

  def create_organization_repositories
    if object.tracked
      HookService.new.subscribe(object)
      GithubWorker.perform_async("FETCH_ORG_REPOS", organization_id: object.id)
    elsif !object.id_changed?
      HookService.new.unsubscribe(object)
    end
  end
end
