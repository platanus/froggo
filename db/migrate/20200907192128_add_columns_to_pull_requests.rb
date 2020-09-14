class AddColumnsToPullRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_requests, :description, :string
    add_column :pull_requests, :commits, :integer
    add_column :pull_requests, :reviewers, :string
  end
end
