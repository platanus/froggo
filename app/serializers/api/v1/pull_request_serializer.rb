class Api::V1::PullRequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :repository_name, :owner_id, :html_url, :likes, :created_at,
             :owner_name, :description, :commits, :owner_login, :organization_id, :gh_number
  def likes
    return object.like_count if object.respond_to? :like_count

    object.likes.count
  end
end
