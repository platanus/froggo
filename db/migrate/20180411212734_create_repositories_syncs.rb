class CreateRepositoriesSyncs < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories_syncs do |t|
      t.references :organization, foreign_key: true
      t.datetime :synced_at

      t.timestamps
    end
  end
end
