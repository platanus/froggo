class PullRequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :repository_name, :owner_id, :html_url, :likes, :created_at, :owner_name
  def likes
    { total: object.likes.count }
  end
end
