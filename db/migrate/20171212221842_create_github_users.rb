class CreateGithubUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :github_users do |t|
      t.string :avatar_url
      t.string :email
      t.integer :ghid
      t.string :html_url
      t.string :login
      t.string :name

      t.timestamps
    end
  end
end
