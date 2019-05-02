class AddDefaultTeamMembershipToOrganizationMemberships < ActiveRecord::Migration[5.1]
  def change
    add_column :organization_memberships, :default_team_membership, :boolean, default: false
  end
end
