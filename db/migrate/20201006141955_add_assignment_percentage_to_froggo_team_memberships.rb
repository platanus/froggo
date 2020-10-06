class AddAssignmentPercentageToFroggoTeamMemberships < ActiveRecord::Migration[6.0]
  def up
    add_column :froggo_team_memberships, :assignment_percentage, :integer
    change_column_default :froggo_team_memberships, :assignment_percentage, 100
  end

  def down
    remove_column :froggo_team_memberships, :assignment_percentage
  end
end
