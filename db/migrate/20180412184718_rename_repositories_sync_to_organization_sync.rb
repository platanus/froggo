class RenameRepositoriesSyncToOrganizationSync < ActiveRecord::Migration[5.1]
  def change
    rename_table :repositories_syncs, :organization_syncs
  end
end
