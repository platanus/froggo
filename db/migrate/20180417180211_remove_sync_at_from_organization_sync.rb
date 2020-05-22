class RemoveSyncAtFromOrganizationSync < ActiveRecord::Migration[5.1]
  def change
    remove_column :organization_syncs, :synced_at
  end
end
