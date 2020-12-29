class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.references :taggable, polymorphic: true, null: false
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
