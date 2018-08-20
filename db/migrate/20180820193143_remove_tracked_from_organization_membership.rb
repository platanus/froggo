class RemoveTrackedFromOrganizationMembership < ActiveRecord::Migration[5.1]
  def change
    remove_column :organization_memberships, :tracked, :boolean
  end
end
