class AddValueToAssignmentPercentage < ActiveRecord::Migration[6.0]
  def up
    FroggoTeamMembership.update_all(assignment_percentage: 100)
  end

  def down; end
end
