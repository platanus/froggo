class AddAssmToOrganizationSync < ActiveRecord::Migration[5.1]
  def change
    add_column :organization_syncs, :state, :string
    add_column :organization_syncs, :start_time, :datetime
    add_column :organization_syncs, :end_time, :datetime
  end
end
