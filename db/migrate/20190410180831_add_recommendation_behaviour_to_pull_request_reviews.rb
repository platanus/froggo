class AddRecommendationBehaviourToPullRequestReviews < ActiveRecord::Migration[5.1]
  def change
    add_column :pull_request_reviews, :recommendation_behaviour, :string, default: 'not_defined'
  end
end
