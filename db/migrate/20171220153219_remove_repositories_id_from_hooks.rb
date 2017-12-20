class RemoveRepositoriesIdFromHooks < ActiveRecord::Migration[5.1]
  def change
    remove_column :hooks, :repositories_id, :bigint
  end
end
