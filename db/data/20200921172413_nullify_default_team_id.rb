class NullifyDefaultTeamId < ActiveRecord::Migration[6.0]
  def up
    Organization.update_all(default_team_id: nil)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
