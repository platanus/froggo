class AddDescriptionToGithubUser < ActiveRecord::Migration[6.0]
  def change
    add_column :github_users, :description, :string
  end
end
