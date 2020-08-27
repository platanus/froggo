class AddApprovedAtToPullRequestReview < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_request_reviews, :approved_at, :datetime
  end
end
