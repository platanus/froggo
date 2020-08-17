class PullRequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :repository_name, :html_url
end
