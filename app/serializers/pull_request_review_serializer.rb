class PullRequestReviewSerializer < ActiveModel::Serializer
  attributes :id, :pull_request_id, :github_user_id, :github_user_name, :github_user_login
end
