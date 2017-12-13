class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.integer :ghid
      t.string :login
      t.string :description
      t.string :html_url
      t.string :avatar_url

      t.timestamps
    end
  end
end
