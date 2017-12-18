class CreatePullRequestRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :pull_request_relations do |t|
      t.references :pull_request, foreign_key: true
      t.references :github_user, foreign_key: true
      t.string :relation_type

      t.timestamps
    end
  end
end
