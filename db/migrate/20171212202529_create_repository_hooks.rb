class CreateRepositoryHooks < ActiveRecord::Migration[5.1]
  def change
    create_table :repository_hooks do |t|
      t.integer :hook_id
      t.integer :repository_id

      t.timestamps
    end
  end
end
