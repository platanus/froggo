class AddDefaultTeamIdToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :default_team_id, :integer
  end
end
