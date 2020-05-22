require 'rails_helper'

describe ComputeGithubContributions do
  def perform(*args)
    described_class.for(*args)
  end

  def perform_with_predefined_args
    perform(
      user_id: user_id,
      other_users_ids: other_users_ids,
      pr_relations: pr_relations
    )
  end

  let(:pr_relations) { Array.new(5) { create(:pull_request_relation) } }
  let(:user_id) { 1 }
  let(:other_users_ids) { [2, 3, 4, 5] }

  before do
    allow_any_instance_of(ComputeGithubContributions)
      .to receive(:gh_user_interactions).and_return(
        2 => 1,
        3 => 2,
        5 => 3
      )
    allow_any_instance_of(ComputeGithubContributions)
      .to receive(:gh_user_merged_pull_req_ids).and_return([1, 2, 3, 4, 5])
    allow_any_instance_of(ComputeGithubContributions)
      .to receive(:gh_user_coop_pull_req_ids).and_return([7, 8])
  end

  context 'self_reviewed_prs' do
    it 'considers self merged prs and prs where other users are reviewers' do
      expect(perform_with_predefined_args[:self_reviewed_prs]).to eq(3)
    end
  end

  context 'per_user_contributions' do
    it 'should have same shape as other_users_ids' do
      expect(perform_with_predefined_args[:per_user_contributions].size)
        .to eq(other_users_ids.length)
    end

    it 'returns result based on interactions' do
      expect(perform_with_predefined_args[:per_user_contributions])
        .to eq([1, 2, 0, 3])
    end
  end
end
