class AdminUserObserver < PowerTypes::Observer
  after_save :create_organizations

  def create_organizations
    if new_token_set?
      service = GithubService.new(user_token: object.token, user_id: object.id)
      service.create_organizations
    end
  end

  private

  def new_token_set?
    object.token_changed? && !object.token.nil?
  end
end
