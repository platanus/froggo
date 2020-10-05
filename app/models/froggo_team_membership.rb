class FroggoTeamMembership < ApplicationRecord
  after_update :update_activation_date, if: :saved_change_to_is_member_active?

  belongs_to :github_user
  belongs_to :froggo_team

  private

  def update_activation_date
    if is_member_active?
      update(last_activation_date: Time.current)
    else
      update(last_deactivation_date: Time.current)
    end
  end
end

# == Schema Information
#
# Table name: froggo_team_memberships
#
#  id                     :bigint(8)        not null, primary key
#  github_user_id         :bigint(8)        not null
#  froggo_team_id         :bigint(8)        not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_member_active       :boolean          default(TRUE)
#  last_deactivation_date :datetime
#  last_activation_date   :datetime
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
