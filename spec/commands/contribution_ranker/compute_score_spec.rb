require 'rails_helper'

describe ContributionRanker::ComputeScore do
  def perform(*args)
    described_class.for(*args)
  end

  context 'when user contributes nothing' do
    it 'returns 0 when there are no other users' do
      expect(perform(self_reviewed_prs: 30, per_user_reviews: [])).to eq(0)
    end
    it 'returns 0 when there are multiple other users' do
      expect(perform(self_reviewed_prs: 30, per_user_reviews: [0, 0, 0])).to eq(0)
    end
  end

  context 'when user contributes something' do
    it 'is not 0' do
      expect(perform(self_reviewed_prs: 30, per_user_reviews: [1, 2, 0]))
        .not_to eq(0)
    end
  end
end
