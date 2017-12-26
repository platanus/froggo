class AdminUserObserver < PowerTypes::Observer
  after_save :create_organizations

  def create_organizations
    if new_token_set?
      service = GithubService.new(user: object)
      service.create_organizations
    end
  end

  private

  def new_token_set?
    object.token_changed? && !object.token.nil?
  end
end
