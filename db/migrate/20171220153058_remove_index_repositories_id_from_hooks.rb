class RemoveIndexRepositoriesIdFromHooks < ActiveRecord::Migration[5.1]
  def change
    remove_index :hooks, name: :index_hooks_on_repositories_id
  end
end
