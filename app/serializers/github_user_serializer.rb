class GithubUserSerializer < ActiveModel::Serializer
  attributes :id, :login, :name, :avatar_url
end
