class CreatePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :preferences do |t|
      t.bigint :default_organization_id
      t.bigint :default_team_id
      t.bigint :default_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
