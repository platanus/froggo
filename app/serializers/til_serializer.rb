class TilSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :github_user
  belongs_to :pull_request
end
