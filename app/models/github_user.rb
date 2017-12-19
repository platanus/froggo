class GithubUser < ApplicationRecord
  has_many :pull_request_relations
  has_many :pull_requests, through: :pull_request_relations

  validates :gh_id, presence: true
  validates :login, presence: true

  def reviewer?(pull_request)
    pull_request.reviewers.where(id: id).empty?
  end

  def assignee?(pull_request)
    pull_request.assignees.where(id: id).empty?
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
