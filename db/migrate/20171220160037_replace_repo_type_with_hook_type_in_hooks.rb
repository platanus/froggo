class ReplaceRepoTypeWithHookTypeInHooks < ActiveRecord::Migration[5.1]
  def change
    rename_column :hooks, :repo_type, :hook_type
  end
end
