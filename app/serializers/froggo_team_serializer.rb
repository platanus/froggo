class FroggoTeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :organization, :members

  def organization
    { id: object.organization.id, login: object.organization.login }
  end

  def members
    object.github_users.map do |user|
      { id: user.id,
        login: user.login }
    end
  end
end
