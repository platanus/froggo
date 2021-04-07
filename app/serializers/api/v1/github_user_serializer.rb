class Api::V1::GithubUserSerializer < ActiveModel::Serializer
  attributes :id, :description, :name, :tags

  def tags
    object.tags.map do |tag|
      Api::V1::TagSerializer.new(tag)
    end
  end
end
