require 'rails_helper'

describe ContributionRanker::ComputeScore do
  def perform(*args)
    described_class.for(*args)
  end

  context 'when user contributes nothing' do
    it do
      expect(perform(self_reviewed_prs: 30, per_user_reviews: [0, 0, 0]))
        .to eq(0)
    end
  end

  context 'when there are no other users' do
    it { expect(perform(self_reviewed_prs: 10, per_user_reviews: [])).to eq(0) }
  end

  context 'when user contributes something' do
    it do
      expect(perform(self_reviewed_prs: 30, per_user_reviews: [1, 2, 0]))
        .not_to eq(0)
    end
  end
end
