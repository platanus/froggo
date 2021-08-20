class RemoveUniqueIndexFromAssignationMetric < ActiveRecord::Migration[6.0]
  def change
    remove_index :assignation_metrics, name: :index_metrics_on_ghuser_and_pr, column: [:github_user_id,:pull_request_id]
  end
end
