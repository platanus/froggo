class CreateFroggoTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :froggo_teams do |t|
      t.string :name

      t.timestamps
    end
  end
end
