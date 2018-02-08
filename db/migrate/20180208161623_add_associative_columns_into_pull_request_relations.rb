class AddAssociativeColumnsIntoPullRequestRelations < ActiveRecord::Migration[5.1]
  def change
    add_column :pull_request_relations, :organization_id, :integer
    add_column :pull_request_relations, :target_user_id, :integer
    add_column :pull_request_relations, :gh_updated_at, :datetime

    add_index :pull_request_relations, :organization_id
    add_index :pull_request_relations, :target_user_id
    add_index :pull_request_relations, :gh_updated_at
  end
end
