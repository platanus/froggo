class Organization < ApplicationRecord
  include PowerTypes::Observable

  has_many :repositories
  has_many :hooks, as: :resource
  has_many :organization_memberships
  has_many :members, through: :organization_memberships, source: :github_user
  has_many :froggo_teams, dependent: :destroy

  validates :gh_id, presence: true
  validates :login, presence: true

  def sorted_repositories
    repositories.order('tracked DESC NULLS LAST, gh_updated_at DESC')
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id              :bigint(8)        not null, primary key
#  gh_id           :integer
#  login           :string
#  description     :string
#  html_url        :string
#  avatar_url      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string
#  tracked         :boolean
#  public_enabled  :boolean
#  default_team_id :integer
#
