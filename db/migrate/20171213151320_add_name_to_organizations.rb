class AddNameToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :name, :string
  end
end
