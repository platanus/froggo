class CreateRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories do |t|
      t.integer :gh_id
      t.string :name
      t.string :full_name
      t.boolean :tracked
      t.string :url
      t.string :html_url

      t.timestamps
    end
  end
end
