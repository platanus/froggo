class AddTrackedToGithubUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :github_users, :tracked, :boolean
  end
end
