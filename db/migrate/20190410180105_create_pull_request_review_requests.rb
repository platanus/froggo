class CreatePullRequestReviewRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :pull_request_review_requests do |t|
      t.references :pull_request, foreign_key: true
      t.references :github_user, foreign_key: true
      t.integer :gh_id

      t.timestamps
    end
  end
end
