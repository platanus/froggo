class AddIndexToGithubUserLogin < ActiveRecord::Migration[5.1]
  def change
    add_index :github_users, :login
  end
end
