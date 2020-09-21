class PullRequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :repository_name, :owner_id, :html_url, :likes, :created_at,
             :owner_name, :description, :commits, :owner_login
  def likes
    object.likes.count
  end
end
