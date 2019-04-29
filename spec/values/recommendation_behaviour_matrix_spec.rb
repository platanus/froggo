require 'rails_helper'

RSpec.describe RecommendationBehaviourMatrix, type: :class do
  let!(:organization) { create(:organization) }
  let!(:repository) { create(:repository, organization: organization) }
  let!(:reviewer) { create(:github_user, gh_id: 8, login: 'gh_reviewer') }
  let!(:owner) { create(:github_user, gh_id: 3, login: 'gh_owner') }
  let!(:reviewer_membership) do
    create(:organization_membership, organization: organization, github_user: reviewer)
  end
  let!(:owner_membership) do
    create(:organization_membership, organization: organization, github_user: owner)
  end
  let!(:pull_requests) do
    Array.new(3) do
      create(:pull_request, repository: repository, owner: owner)
    end
  end
  let!(:pr_relation1) do
    create(
      :pull_request_relation,
      pull_request: pull_requests[0],
      github_user_id: reviewer.id,
      recommendation_behaviour: :obedient
    )
  end
  let!(:pr_relation2) do
    create(
      :pull_request_relation,
      pull_request: pull_requests[1],
      github_user_id: reviewer.id,
      recommendation_behaviour: :obedient
    )
  end
  let!(:pr_relation3) do
    create(
      :pull_request_relation,
      pull_request: pull_requests[2],
      github_user_id: reviewer.id,
      recommendation_behaviour: :indifferent
    )
  end

  let!(:default_ids) { [owner.gh_id, reviewer.gh_id] }

  context 'when initialized' do
    subject do
      RecommendationBehaviourMatrix.new(organization.id, default_ids)
    end

    it 'values are zero' do
      expect(subject.data[[0, 0]]).to eq(0)
    end
  end

  context 'when matrix is filled' do
    subject do
      RecommendationBehaviourMatrix.new(organization.id, default_ids)
    end

    it 'should mutate data' do
      expect { subject.fill_matrix }.to change { subject.data.length }.by(6)
    end

    it 'should count correct amount of behaviour instances' do
      subject.fill_matrix
      expect(subject.data[[0, 0]]).to eq(2)
      expect(subject.data[[0, 1]]).to eq(1)
      expect(subject.data[[0, 2]]).to eq(0)
    end
  end

  context 'when matrix is ordered' do
    subject do
      RecommendationBehaviourMatrix.new(organization.id, default_ids)
    end

    it 'should place user with most statistics first' do
      expect(subject.team_members.first).to have_attributes(gh_id: 3)
    end
  end
end
