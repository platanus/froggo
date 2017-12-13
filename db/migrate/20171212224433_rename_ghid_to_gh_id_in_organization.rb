class RenameGhidToGhIdInOrganization < ActiveRecord::Migration[5.1]
  def change
    rename_column :organizations, :ghid, :gh_id
  end
end
