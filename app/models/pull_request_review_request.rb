class PullRequestReviewRequest < ApplicationRecord
  belongs_to :pull_request
  belongs_to :github_user, optional: true
end

# == Schema Information
#
# Table name: pull_request_review_requests
#
#  id              :bigint(8)        not null, primary key
#  pull_request_id :bigint(8)
#  github_user_id  :bigint(8)
#  gh_id           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_pull_request_review_requests_on_github_user_id   (github_user_id)
#  index_pull_request_review_requests_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#
