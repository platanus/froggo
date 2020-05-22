require 'rails_helper'

describe ComputeUserStatistics do
  def perform(*_args)
    described_class.for(*_args)
  end

  def perform_organization_with_no_relations
    perform(
      github_user_id: github_user1_id,
      organization_id: organization2_id
    )
  end

  def perform_user_with_no_relations
    perform(
      github_user_id: github_user2_id,
      organization_id: organization1_id
    )
  end

  def perform_user_and_org_with_relations
    perform(
      github_user_id: github_user1_id,
      organization_id: organization1_id
    )
  end

  let(:github_user1_id) { 1 }
  let(:github_user2_id) { 2 }
  let(:organization1_id) { 1 }
  let(:organization2_id) { 2 }
  let!(:pull_request_relation1) do
    create(
      :pull_request_relation,
      target_user_id: github_user1_id,
      organization_id: organization1_id,
      recommendation_behaviour: :obedient
    )
  end

  let!(:pull_request_relation2) do
    create(
      :pull_request_relation,
      target_user_id: github_user1_id,
      organization_id: organization1_id,
      recommendation_behaviour: :obedient
    )
  end

  let!(:pull_request_relation3) do
    create(
      :pull_request_relation,
      target_user_id: github_user1_id,
      organization_id: organization1_id,
      recommendation_behaviour: :indifferent
    )
  end

  context 'no pull request relations belong to the organization' do
    it 'doesnt count any relation' do
      statistics = perform_organization_with_no_relations
      total_counts = statistics[:obedient] + statistics[:indifferent] +
        statistics[:rebel] + statistics[:not_defined]
      expect(total_counts).to eq(0)
    end
  end

  context 'no pull request relations belong to github user' do
    it 'doesnt count any relation' do
      statistics = perform_user_with_no_relations
      total_counts = statistics[:obedient] + statistics[:indifferent] +
        statistics[:rebel] + statistics[:not_defined]
      expect(total_counts).to eq(0)
    end
  end

  context 'pull request relations belong to github user and organization' do
    context 'when more than 1 relation fit criteria' do
      it 'saves correct amount of relations' do
        expect(perform_user_and_org_with_relations[:obedient]).to eq(2)
      end
    end

    context 'when 1 relation fits criteria' do
      it 'saves correct amount of relations' do
        expect(perform_user_and_org_with_relations[:indifferent]).to eq(1)
      end
    end

    context 'when 0 relations fit criteria' do
      it 'saves correct amount of relations' do
        expect(perform_user_and_org_with_relations[:rebel]).to eq(0)
      end
    end

    context 'total field fits all criteria' do
      it 'saves correct amount of relations' do
        expect(perform_user_and_org_with_relations[:total]).to eq(3)
      end
    end
  end
end
