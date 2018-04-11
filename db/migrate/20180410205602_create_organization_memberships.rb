class CreateOrganizationMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_memberships do |t|
      t.references :github_user, foreign_key: true
      t.references :organization, foreign_key: true
      t.boolean :tracked, default: true

      t.timestamps
    end
  end
end
