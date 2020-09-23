class AddMemberActiveToFroggoTeamMemberships < ActiveRecord::Migration[6.0]
  def up
    add_column :froggo_team_memberships, :is_member_active, :boolean
    change_column_default :froggo_team_memberships, :is_member_active, true
  end

  def down
    remove_column :froggo_team_memberships, :is_member_active
  end
end
