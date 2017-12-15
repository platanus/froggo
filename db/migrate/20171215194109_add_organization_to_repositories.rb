class AddOrganizationToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_reference :repositories, :organization, foreign_key: true
  end
end
