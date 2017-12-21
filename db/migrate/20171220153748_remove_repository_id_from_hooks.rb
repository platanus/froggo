class RemoveRepositoryIdFromHooks < ActiveRecord::Migration[5.1]
  def change
    remove_column :hooks, :repository_id, :integer
  end
end
