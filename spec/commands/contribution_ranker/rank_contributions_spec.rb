require 'rails_helper'

describe ContributionRanker::RankContributions do
  def perform(*args)
    described_class.for(*args)
  end

  let(:users_contributions) do
    {
      [0, 0] => 0, [0, 1] => 20, [0, 2] => 0,
      [1, 0] => 10, [1, 1] => 0, [1, 2] => 0,
      [2, 0] => 10, [2, 1] => 1, [2, 2] => 0
    }
  end

  it 'has at most "limit" results' do
    expect(perform(users_contributions: users_contributions, limit: 1).length)
      .to be <= 1
    expect(perform(users_contributions: users_contributions, limit: 2).length)
      .to be <= 2
    expect(perform(users_contributions: users_contributions, limit: 3).length)
      .to be <= 3
    expect(perform(users_contributions: users_contributions, limit: 100).length)
      .to eq(3)
  end

  context 'on incomplete data' do
    let (:contributions_with_missing_data) do
      # Missing [1, 1]
      {
        [0, 0] => 0, [0, 1] => 0,
        [1, 0] => 0
      }
    end

    it 'raises ArgumentError' do
      expect do
        perform(users_contributions: contributions_with_missing_data, limit: 3)
      end.to raise_error(ArgumentError)
    end
  end
end
