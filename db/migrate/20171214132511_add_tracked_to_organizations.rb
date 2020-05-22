class AddTrackedToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :tracked, :boolean
  end
end
