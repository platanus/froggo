class AddLastActivationDateToFroggoTeamMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :froggo_team_memberships, :last_activation_date, :datetime
  end
end
