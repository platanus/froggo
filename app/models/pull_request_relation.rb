class PullRequestRelation < ApplicationRecord
  extend Enumerize
  belongs_to :pull_request
  belongs_to :github_user

  enumerize :pr_relation_type, in: [:merged_by, :reviewer]
  validates :pr_relation_type, presence: true
  validates_inclusion_of :pr_relation_type, in: %w(merged_by reviewer)

  scope :merged_relations, -> { where(pr_relation_type: :merged_by) }
  scope :review_relations, -> { where(pr_relation_type: :reviewer) }
  scope :within_month_limit, ->(limit) do
    where('gh_updated_at > ?', Time.current - limit.months)
  end
  scope :by_pull_request, ->(pr_id) {  where(pull_request_id: pr_id) }
  scope :by_organizations, ->(organization_ids) { where(organization_id: organization_ids) }

  def self.participants_ids
    group(:github_user_id).pluck(:github_user_id) | group(:target_user_id).pluck(:target_user_id)
  end
end
# rubocop:disable LineLength

# == Schema Information
#
# Table name: pull_request_relations
#
#  id               :integer          not null, primary key
#  pull_request_id  :integer
#  github_user_id   :integer
#  pr_relation_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  organization_id  :integer
#  target_user_id   :integer
#  gh_updated_at    :datetime
#
# Indexes
#
#  index_pr_relations_on_orgs_and_updated_and_all_users     (organization_id,gh_updated_at,github_user_id,target_user_id)
#  index_pr_relations_on_orgs_and_updated_and_user_and_prs  (organization_id,gh_updated_at,github_user_id,pull_request_id)
#  index_pull_request_relations_on_gh_updated_at            (gh_updated_at)
#  index_pull_request_relations_on_github_user_id           (github_user_id)
#  index_pull_request_relations_on_organization_id          (organization_id)
#  index_pull_request_relations_on_pull_request_id          (pull_request_id)
#  index_pull_request_relations_on_target_user_id           (target_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#
