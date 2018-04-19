class RenameLastUpdateForGhLastUpdate < ActiveRecord::Migration[5.1]
  def change
    rename_column :repositories, :last_update, :gh_updated_at
  end
end
