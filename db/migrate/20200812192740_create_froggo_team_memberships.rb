class CreateFroggoTeamMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :froggo_team_memberships do |t|
      t.references :github_user, null: false, foreign_key: true
      t.references :froggo_team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
