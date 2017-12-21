require 'rails_helper'

RSpec.describe CorrelationMatrix, type: :class do
  let (:user1) { create(:github_user) }
  let (:user2) { create(:github_user) }

  subject { CorrelationMatrix.new([user1, user2]) }

  context "when initialized" do
    it { expect(subject.data[[0, 0]]).to eq(0) }
  end

  context "when update" do
    it "should increase value if user exists" do
      i = subject.row_head.find_index(user1)
      j = subject.row_head.find_index(user2)

      expect do
        subject.update_data(user1, user2)
      end.to change { subject.data[[i, j]] }.by(1)
    end

    it "should keep old value if don't exist" do
      expect(subject.update_data("", "")).to be_nil
    end
  end

  context "when fill_matrix" do
    let!(:owner) { create(:github_user) }
    let!(:reviewer) { create(:github_user) }
    let!(:pull_requests) do
      [create(:pull_request, owner: owner, reviewers: [reviewer])]
    end

    subject { CorrelationMatrix.new([owner, reviewer]) }

    it "should keep old value if don't exist" do
      i = subject.row_head.find_index(owner)
      j = subject.row_head.find_index(reviewer)
      expect do
        subject.fill_matrix(pull_requests)
      end.to change { subject.data[[i, j]] }.by(1)
    end
  end
end
