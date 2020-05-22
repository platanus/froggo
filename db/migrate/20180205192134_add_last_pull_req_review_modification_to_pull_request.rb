class AddLastPullReqReviewModificationToPullRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :pull_requests, :last_pull_req_review_modification, :datetime
    PullRequest.reset_column_information
    PullRequest.all.each do |pull_req|
      if pull_req.pull_request_reviews.present?
        pull_req.update!(
          last_pull_req_review_modification: pull_req.pull_request_reviews.last.updated_at
        )
      else
        pull_req.update!(last_pull_req_review_modification: pull_req.created_at)
      end
    end
  end
end
