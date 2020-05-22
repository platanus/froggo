class RemoveColumnLastPrReviewsModification < ActiveRecord::Migration[5.1]
  def change
    remove_column :pull_requests, :last_pull_req_review_modification, :datetime
  end
end
