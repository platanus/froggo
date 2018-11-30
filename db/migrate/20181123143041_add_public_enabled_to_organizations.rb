class AddPublicEnabledToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :public_enabled, :boolean
  end
end
