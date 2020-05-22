class AddGithubTokenToAdminUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :token, :string
    add_column :admin_users, :uid, :string
  end
end
