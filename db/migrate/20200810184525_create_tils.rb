class CreateTils < ActiveRecord::Migration[6.0]
  def change
    create_table :tils do |t|
      t.references :github_user, null: false, foreign_key: true
      t.references :pull_request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
