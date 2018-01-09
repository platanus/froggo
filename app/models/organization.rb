class Organization < ApplicationRecord
  include PowerTypes::Observable

  belongs_to :owner, class_name: "AdminUser"
  has_many :repositories
  has_many :hooks, as: :resource

  validates :gh_id, presence: true
  validates :login, presence: true

  def participants
    GithubUser
      .joins(pull_request_relations: { pull_request: :repository })
      .where(pull_request_relations: { pull_requests: { repositories: { organization_id: id } } })
      .group(:id)
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  gh_id       :integer
#  login       :string
#  description :string
#  html_url    :string
#  avatar_url  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#  tracked     :boolean
#  owner_id    :integer
#
