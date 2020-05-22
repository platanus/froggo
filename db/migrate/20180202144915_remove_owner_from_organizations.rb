class RemoveOwnerFromOrganizations < ActiveRecord::Migration[5.1]
  def change
    remove_column :organizations, :owner_id, :integer
  end
end
