class RenameGhidToGhIdInGithubUser < ActiveRecord::Migration[5.1]
  def change
    rename_column :github_users, :ghid, :gh_id
  end
end
