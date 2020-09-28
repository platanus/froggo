class FroggoTeamMembership < ApplicationRecord
  belongs_to :github_user
  belongs_to :froggo_team
end

# == Schema Information
#
# Table name: froggo_team_memberships
#
#  id               :bigint(8)        not null, primary key
#  github_user_id   :bigint(8)        not null
#  froggo_team_id   :bigint(8)        not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  is_member_active :boolean          default(TRUE)
#
# Indexes
#
#  index_froggo_team_memberships_on_froggo_team_id  (froggo_team_id)
#  index_froggo_team_memberships_on_github_user_id  (github_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (froggo_team_id => froggo_teams.id)
#  fk_rails_...  (github_user_id => github_users.id)
#
