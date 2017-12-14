class AdminUserObserver < PowerTypes::Observer
  after_save :create_organizations

  def create_organizations
    unless object.token.nil?
      service = GithubService.new(user: object)
      service.create_organizations
    end
  end
end
