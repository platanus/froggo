class AddDefaultTeamMembershipToOrganizationMemberships < ActiveRecord::Migration[5.1]
  def change
    add_column :organization_memberships, :is_member_of_default_team, :boolean, default: false
  end
end
