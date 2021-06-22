class PreferencePolicy < ApplicationPolicy
  def show?
    record.github_user_id == user.id
  end

  def update?
    record.github_user_id == user.id
  end
end
