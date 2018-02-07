require 'rails_helper'

RSpec.describe CorrelationMatrix, type: :class do
  let!(:organization) { create(:organization) }
  let!(:repository) { create(:repository, organization: organization) }

  context 'when initialized with empty organization' do
    subject { CorrelationMatrix.new(organization.gh_id) }
    it 'has empty data' do
      expect(subject.data).to be_empty
    end
  end

  context 'when initialized' do
    let!(:owner) { create(:github_user, gh_id: 3, tracked: true, login: 'gh_owner') }
    let!(:pull_requests) { [create(:pull_request, repository: repository, owner: owner)] }
    let!(:reviewer) { create(:github_user, gh_id: 8, tracked: true, login: 'gh_reviewer') }
    let!(:pr_relation) do
      create(:pull_request_relation, pull_request: pull_requests[0], github_user: reviewer)
    end

    subject { CorrelationMatrix.new(organization.gh_id) }
    it 'has zeros value' do
      expect(subject.data[[0, 0]]).to eq(0)
    end
  end

  context 'when fill_matrix' do
    let!(:owner) { create(:github_user, gh_id: 3, tracked: true, login: 'gh_owner') }
    let!(:reviewer) { create(:github_user, gh_id: 8, tracked: true, login: 'gh_reviewer') }
    let!(:pull_requests) { [create(:pull_request, repository: repository, owner: owner)] }
    before do
      create(:pull_request_relation, pull_request: pull_requests[0], github_user: owner)
      create(:pull_request_relation, pull_request: pull_requests[0], github_user: reviewer)
    end

    subject { CorrelationMatrix.new(organization.gh_id) }

    it 'should change data value if exist' do
      expect do
        subject.fill_matrix
      end.to change { subject.data.length }.by(3)
    end

    fit 'should assign cooperate scope correctly' do
      subject.fill_matrix
      expect(subject.data[[0, 1]] + subject.data[[1, 0]]).to be(1)
      expect(subject.data[[0, 0]]).to be(0)
      expect(subject.data[[1, 1]]).to be(0)
    end

    it 'should assign alone score correctly' do
      new_pr = create(:pull_request, repository: repository, owner: owner)
      create(:pull_request_relation, pull_request: new_pr, github_user: owner,
                                     pr_relation_type: :merged_by)
      create(:pull_request_relation, pull_request: new_pr, github_user: owner,
                                     pr_relation_type: :reviewer)
      subject.fill_matrix
      expect(subject.data[[0, 0]]).to be(1)
    end
  end
end
