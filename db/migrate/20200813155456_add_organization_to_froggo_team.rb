class AddOrganizationToFroggoTeam < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :froggo_teams, :organization, index: {algorithm: :concurrently}
  end
end
