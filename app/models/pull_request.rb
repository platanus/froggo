class PullRequest < ApplicationRecord
  include PowerTypes::Observable

  belongs_to :repository
  belongs_to :owner, class_name: 'GithubUser'
  belongs_to :merged_by, class_name: 'GithubUser', optional: true

  has_many :pull_request_reviews, dependent: :destroy
  has_many :pull_request_reviewers, through: :pull_request_reviews, source: :github_user

  has_many :pull_request_relations, dependent: :destroy
  has_many :pull_request_review_requests, dependent: :destroy

  scope :within_month_limit, -> do
    where('pull_requests.gh_updated_at > ?',
      Time.current - ENV['PULL_REQUEST_MONTH_LIMIT'].to_i.months)
  end

  scope :by_organizations, ->(organization_ids) do
    joins(:repository).where(repositories: { organization_id: organization_ids })
  end

  validates :gh_id, presence: true
  validates :pr_state, presence: true, inclusion: { in: %w(open closed) }
end

# == Schema Information
#
# Table name: pull_requests
#
#  id            :integer          not null, primary key
#  gh_id         :integer
#  title         :string
#  gh_number     :integer
#  pr_state      :string
#  html_url      :string
#  gh_created_at :datetime
#  gh_updated_at :datetime
#  gh_closed_at  :datetime
#  gh_merged_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  repository_id :integer
#  owner_id      :integer
#  merged_by_id  :integer
#
# Indexes
#
#  index_pull_requests_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (merged_by_id => github_users.id)
#  fk_rails_...  (repository_id => repositories.id)
#
