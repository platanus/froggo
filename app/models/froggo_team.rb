class FroggoTeam < ApplicationRecord
  include PowerTypes::Observable

  has_many :froggo_team_memberships, dependent: :destroy
  has_many :github_users, through: :froggo_team_memberships

  belongs_to :organization
end

# == Schema Information
#
# Table name: froggo_teams
#
#  id              :bigint(8)        not null, primary key
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint(8)
#
# Indexes
#
#  index_froggo_teams_on_organization_id  (organization_id)
#
