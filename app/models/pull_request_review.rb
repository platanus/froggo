class PullRequestReview < ApplicationRecord
  include PowerTypes::Observable
  extend Enumerize

  belongs_to :pull_request
  belongs_to :github_user

  enumerize :recommendation_behaviour, in: [:obedient, :indifferent, :rebel, :not_defined]

  delegate :name, to: :github_user, prefix: true
  delegate :login, to: :github_user, prefix: true
end

# == Schema Information
#
# Table name: pull_request_reviews
#
#  id                       :bigint(8)        not null, primary key
#  pull_request_id          :bigint(8)
#  github_user_id           :bigint(8)
#  gh_id                    :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  recommendation_behaviour :string           default("not_defined")
#  approved_at              :datetime
#
# Indexes
#
#  index_pull_request_reviews_on_github_user_id   (github_user_id)
#  index_pull_request_reviews_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#
