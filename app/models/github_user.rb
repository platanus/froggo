class GithubUser < ApplicationRecord
  has_many :pull_request_relations
  has_many :pull_request_review_requests, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_many :pull_requests, foreign_key: :owner_id
  has_many :pull_request_reviews
  has_many :pull_requests_reviewed, through: :pull_request_reviews, source: :pull_request
  has_many :pull_requests_merged, class_name: 'PullRequest', foreign_key: :merged_by_id

  has_many :organization_memberships
  has_many :organizations, through: :organization_memberships, source: :organization

  has_many :froggo_team_memberships, dependent: :destroy
  has_many :froggo_teams, through: :froggo_team_memberships

  validates :gh_id, presence: true
  validates :login, presence: true
end

# == Schema Information
#
# Table name: github_users
#
#  id         :bigint(8)        not null, primary key
#  avatar_url :string
#  email      :string
#  gh_id      :integer
#  html_url   :string
#  login      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_users_on_login  (login)
#
