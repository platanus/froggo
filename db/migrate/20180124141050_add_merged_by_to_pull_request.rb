class AddMergedByToPullRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :pull_requests, :merged_by_id, :integer
    add_foreign_key :pull_requests, :github_users, column: :merged_by_id
    PullRequest.reset_column_information
    PullRequest.joins(:pull_request_relations)
      .where(pull_request_relations: { pr_relation_type: :merge_by }).each do |pr|
      pr.merged_by = pr.merge_users.first
      pr.save
    end
  end
end
