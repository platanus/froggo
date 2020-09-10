class FixApprovedAtValuesForPullRequestReviews < ActiveRecord::Migration[6.0]
  def up
    reviews = PullRequestReview.where.not(approved_at: nil).where('approved_at < created_at')
    reviews.each do |review|
      review.approved_at += 1.minute
      review.save
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
