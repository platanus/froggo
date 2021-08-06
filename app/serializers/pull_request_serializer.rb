class PullRequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :repository_name, :owner_id, :html_url, :created_at,
             :owner_name, :description, :commits, :owner_login
end
