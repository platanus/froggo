class RemoveTrackedFromGithubUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :github_users, :tracked, :boolean
  end
end
