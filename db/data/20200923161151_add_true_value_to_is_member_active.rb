class AddTrueValueToIsMemberActive < ActiveRecord::Migration[6.0]
  def up
    FroggoTeamMembership.update_all(is_member_active: true)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
