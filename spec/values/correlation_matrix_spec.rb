require 'rails_helper'

RSpec.describe CorrelationMatrix, type: :class do
  let!(:organization) { create(:organization) }
  let!(:repository) { create(:repository, organization: organization) }

  context 'when initialized with empty organization' do
    let!(:current_user) { create(:github_user, gh_id: 8, login: 'gh_reviewer') }
    subject { CorrelationMatrix.new(organization.id, nil, current_user.login) }
    it 'has empty data' do
      expect(subject.data).to be_empty
    end
  end

  context 'when initialized' do
    let!(:owner) { create(:github_user, gh_id: 3, login: 'gh_owner') }
    let!(:pull_requests) { [create(:pull_request, repository: repository, owner: owner)] }
    let!(:reviewer) { create(:github_user, gh_id: 8, login: 'gh_reviewer') }
    let!(:current_user) { create(:github_user, gh_id: 8, login: 'gh_reviewer') }
    let!(:pr_relation) do
      create(:pull_request_relation, pull_request: pull_requests[0], github_user: reviewer)
    end

    subject { CorrelationMatrix.new(organization.id, nil, current_user.login) }
    it 'has zeros value' do
      expect(subject.data[[0, 0]]).to eq(0)
    end
  end

  context 'when fill_matrix' do
    let!(:owner) { create(:github_user, gh_id: 3, login: 'gh_owner') }
    let!(:reviewer) { create(:github_user, gh_id: 8, login: 'gh_reviewer') }
    let!(:pull_requests) { [create(:pull_request, repository: repository, owner: owner)] }
    let!(:current_user) { create(:github_user, gh_id: 8, login: 'gh_owner') }
    before do
      create(:pull_request_relation, pull_request: pull_requests[0], github_user: owner)
      create(:pull_request_relation, pull_request: pull_requests[0], github_user: reviewer)
    end

    subject { CorrelationMatrix.new(organization.id, nil, current_user.login) }

    it 'should change data value if exist' do
      expect do
        subject.fill_matrix
      end.to change { subject.data.length }.by(0)
    end

    it 'should assign cooperate scope correctly' do
      subject.fill_matrix
      expect(subject.data[[subject.pos_hash[owner.id], subject.pos_hash[reviewer.id]]]).to be(0)
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
      expect(subject.data[[subject.pos_hash[owner.id], subject.pos_hash[owner.id]]]).to be(0)
    end
  end

  context 'filter by user_ids' do
    let!(:owner) { create(:github_user, gh_id: 3, login: 'gh_owner') }
    let!(:reviewer) { create(:github_user, gh_id: 8, login: 'gh_reviewer') }
    let!(:other) { create(:github_user, gh_id: 9, login: 'gh_other') }
    let!(:owner_membership) do
      create(:organization_membership, organization: organization, github_user: owner)
    end
    let!(:reviewer_membership) do
      create(:organization_membership, organization: organization, github_user: reviewer)
    end
    let!(:other_membership) do
      create(:organization_membership, organization: organization, github_user: other)
    end
    let!(:pull_requests) { [create(:pull_request, repository: repository, owner: owner)] }
    let!(:current_user) { create(:github_user, gh_id: 8, login: 'gh_reviewer') }
    before do
      create(:pull_request_relation, pull_request: pull_requests[0], github_user_id: owner.id)
      create(:pull_request_relation, pull_request: pull_requests[0], github_user_id: reviewer.id)
      create(:pull_request_relation, pull_request: pull_requests[0], github_user_id: other.id)
    end

    subject do
      CorrelationMatrix.new(organization.id, [owner.gh_id, reviewer.gh_id], current_user.login)
    end

    it 'should ignore selected users' do
      subject.fill_matrix
      expect(organization.members.length).to eq(3)
      expect(subject.selected_users.length).to eq(2)
    end
  end

  context 'order selected users' do
    let!(:owner) { create(:github_user, gh_id: 3, login: 'gh_owner') }
    let!(:reviewer) { create(:github_user, gh_id: 8, login: 'gh_reviewer') }
    let!(:other) { create(:github_user, gh_id: 9, login: 'gh_other') }
    let!(:reviewer_membership) do
      create(:organization_membership, organization: organization, github_user: reviewer)
    end
    let!(:owner_membership) do
      create(:organization_membership, organization: organization, github_user: owner)
    end
    let!(:other_membership) do
      create(:organization_membership, organization: organization, github_user: other)
    end
    let!(:pull_requests) { [create(:pull_request, repository: repository, owner: owner)] }
    let!(:current_user) { create(:github_user, gh_id: 8, login: 'gh_owner') }
    before do
      create(:pull_request_relation, pull_request: pull_requests[0], github_user_id: owner.id)
      create(:pull_request_relation, pull_request: pull_requests[0], github_user_id: reviewer.id)
      create(:pull_request_relation, pull_request: pull_requests[0], github_user_id: other.id)
    end

    subject do
      CorrelationMatrix.new(organization.id, [owner.gh_id, reviewer.gh_id], current_user.login)
    end

    it 'should place current user first' do
      subject.fill_matrix
      expect(subject.selected_users.first.login).to eq('gh_owner')
    end
  end
end
