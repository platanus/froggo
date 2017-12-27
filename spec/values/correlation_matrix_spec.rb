require 'rails_helper'

RSpec.describe CorrelationMatrix, type: :class do
  let (:user1) { create(:github_user) }
  let (:user2) { create(:github_user) }

  subject { CorrelationMatrix.new([user1, user2]) }

  context "when initialized" do
    it { expect(subject.data[[0, 0]]).to eq(0) }
  end

  context "when fill_matrix" do
    let!(:owner) { create(:github_user, gh_id: 3, tracked: true) }
    let!(:reviewer) { create(:github_user, gh_id: 8, tracked: true) }
    let!(:pull_requests) do
      [create(:pull_request, owner: owner, reviewers: [reviewer])]
    end

    subject { CorrelationMatrix.new([owner, reviewer]) }

    it "should change data value if exist" do
      expect do
        subject.fill_matrix
      end.to change { subject.data.length }.by(3)
    end

    it 'should assign cooperate scope correctly' do
      subject.fill_matrix
      expect(subject.data[[0, 1]]).to be(1)
    end

    it 'should assign alone score correctly' do
      create(:pull_request, owner: owner, merge_users: [owner])
      subject.fill_matrix
      expect(subject.data[[0, 0]]).to be(1)
    end
  end
end
