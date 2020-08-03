require 'rails_helper'

describe ComputeColorScore do
  def perform(*args)
    described_class.for(*args)
  end

  def perform_with_predefined_args
    perform(
      user_id: user.id,
      other_users_ids: other_users.pluck(:id),
      pr_relations: pr_relations
    )
  end

  let(:user) { create(:github_user) }
  let(:other_users_ids) { [2, 3, 4, 5] }
  let(:other_users) do
    create_list(:github_user, 4) do |user, i|
      user.id = other_users_ids[i]
      user.save!
    end
  end

  context 'with  different user interactions' do
    let(:pr_relations_array) do
      create_list(:pull_request_relation, 6) do |pr_relation, i|
        pr_relation.target_user_id = user.id
        pr_relation.github_user_id = 1 + 2**(i.to_f / 3).ceil
        pr_relation.save!
      end
    end
    let(:pr_relations) { PullRequestRelation.where(id: pr_relations_array.pluck(:id)) }

    it 'returns the proper score' do
      expect(perform_with_predefined_args).to eq(2 => 0.5, 3 => 1.5, 4 => 0.0, 5 => 1.0)
    end
  end

  context 'without user interactions' do
    let(:pr_relations_array) { Array.new(5) { create(:pull_request_relation) } }
    let(:pr_relations) { PullRequestRelation.where(id: pr_relations_array.pluck(:id)) }

    it 'returns the proper placeholder scores' do
      expect(perform_with_predefined_args).to eq(2 => -1, 3 => -1, 4 => -1, 5 => -1)
    end
  end
end
