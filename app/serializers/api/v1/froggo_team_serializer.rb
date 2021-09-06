class Api::V1::FroggoTeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :organization, :members

  has_many :github_users, serializer: Api::V1::GithubUserSerializer, if: :with_users?

  def with_users?
    @instance_options[:with_users]
  end

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
