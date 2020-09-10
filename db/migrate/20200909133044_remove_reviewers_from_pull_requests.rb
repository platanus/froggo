class RemoveReviewersFromPullRequests < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :pull_requests, :reviewers, :string }
  end
end
