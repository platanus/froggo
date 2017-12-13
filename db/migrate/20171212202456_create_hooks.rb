class CreateHooks < ActiveRecord::Migration[5.1]
  def change
    create_table :hooks do |t|
      t.string :type
      t.integer :gh_id
      t.string :name
      t.boolean :active
      t.string :ping_url
      t.string :test_url
      t.integer :repository_id
      t.belongs_to :repositories, index: true
      t.timestamps
    end
  end
end
