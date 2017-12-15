class OrganizationObserver < PowerTypes::Observer
  after_save :create_organization_repositories

  def create_organization_repositories
    if object.tracked
      GithubWorker.perform_async("FETCH_ORG_REPOS", organization_id: object.id)
    end
  end
end
