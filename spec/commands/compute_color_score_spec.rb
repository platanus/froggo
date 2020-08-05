require 'rails_helper'

describe ComputeColorScore do
  def perform(*args)
    described_class.for(*args)
  end

  def perform_with_predefined_args
    perform(
      user_id: user.id,
      team_users_ids: other_users.pluck(:id),
      pr_relations: pr_relations
    )
  end

  let(:user) { create(:github_user) }
  let(:other_users) { create_list(:github_user, 4) }

  context 'with different user interactions' do
    let(:pr_relations_array) do
      [create(:pull_request_relation, target_user_id: user.id, github_user_id: other_users[0].id)] +
        create_list(:pull_request_relation, 3, target_user_id: user.id,
                                               github_user_id: other_users[1].id) +
        create_list(:pull_request_relation, 2, target_user_id: user.id,
                                               github_user_id: other_users[3].id)
    end
    let(:pr_relations) { PullRequestRelation.where(id: pr_relations_array.pluck(:id)) }
    let(:correct_score) do
      { other_users[0].id => (2.0 / 3),
        other_users[1].id => 2.0,
        other_users[2].id => 0.0,
        other_users[3].id => (4.0 / 3) }
    end

    it 'returns the proper score' do
      expect(perform_with_predefined_args).to eq(correct_score)
    end

    context 'with unrelated interactions' do
      let(:extended_pr_relations_array) do
        pr_relations_array +
          create_list(:pull_request_relation, 2, target_user_id: other_users[0].id) +
          create_list(:pull_request_relation, 3, target_user_id: user.id,
                                                 github_user_id: other_users[1].id,
                                                 gh_updated_at: Time.current - 10.months)
      end
      let(:pr_relations) { PullRequestRelation.where(id: extended_pr_relations_array.pluck(:id)) }

      it 'still returns the same score' do
        expect(perform_with_predefined_args).to eq(correct_score)
      end
    end
  end

  context 'without user interactions' do
    let(:pr_relations_array) { create_list(:pull_request_relation, 5) }
    let(:pr_relations) { PullRequestRelation.where(id: pr_relations_array.pluck(:id)) }

    it 'returns the proper placeholder scores' do
      expect(perform_with_predefined_args).to eq(
        other_users[0].id => -1,
        other_users[1].id => -1,
        other_users[2].id => -1,
        other_users[3].id => -1
      )
    end
  end
end
