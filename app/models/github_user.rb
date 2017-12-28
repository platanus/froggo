class GithubUser < ApplicationRecord
  has_many :pull_request_relations

  has_many :pull_requests, foreign_key: :owner_id

  validates :gh_id, presence: true
  validates :login, presence: true

  scope :tracked, -> { where(tracked: true) }

  def interactions
    PullRequestRelation.dashboard_limit
                       .where(pull_requests: { owner_id: id })
                       .where(github_user_id: GithubUser.tracked.pluck(:id))
                       .where.not(github_user_id: id)
                       .group(:github_user_id).count
  end

  # Get user pull requests where had been merged by himself
  def merged_pull_requests
    pull_requests.dashboard_limit
                 .joins(:pull_request_relations)
                 .where(pull_request_relations: { pr_relation_type: :merge_by,
                                                  github_user_id: id })
                 .group(:id)
  end

  # Get pull requests where others users had reviewed
  # Params:
  # +pr_ids+ pull request ids to filter
  def coop_pull_requests(pr_ids)
    pull_requests.dashboard_limit
                 .joins(:pull_request_relations)
                 .where(id: pr_ids, pull_request_relations: { pr_relation_type: :reviewer })
                 .where.not(pull_request_relations: { github_user_id: id })
                 .group(:id)
  end
end

# == Schema Information
#
# Table name: github_users
#
#  id         :integer          not null, primary key
#  avatar_url :string
#  email      :string
#  gh_id      :integer
#  html_url   :string
#  login      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tracked    :boolean
#
# Indexes
#
#  index_github_users_on_login  (login)
#
