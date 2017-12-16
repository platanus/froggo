class Repository < ApplicationRecord
  include ActiveModel::Dirty
  include PowerTypes::Observable
  belongs_to :organization
  has_many :pull_requests
  has_many :hooks
  validates :gh_id, presence: true
  validates :full_name, presence: true
end

# == Schema Information
#
# Table name: repositories
#
#  id              :integer          not null, primary key
#  gh_id           :integer
#  name            :string
#  full_name       :string
#  tracked         :boolean
#  url             :string
#  html_url        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#
# Indexes
#
#  index_repositories_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
