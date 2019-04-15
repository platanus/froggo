class AddRecommendationBehaviourToPullRequestRelations < ActiveRecord::Migration[5.1]
  def change
    add_column :pull_request_relations, :recommendation_behaviour, :string, default: 'not_defined'
  end
end
