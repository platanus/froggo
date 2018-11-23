require 'rails_helper'

describe CalculateRanking do
  def perform(data, size, limit)
    described_class.for(data: data, size: size, limit: limit)
  end

  context 'calculate min ranking' do
    let(:data) do
      {
        [0, 0] => 0, [0, 1] => 20, [0, 2] => 0,
        [1, 0] => 10, [1, 1] => 0, [1, 2] => 0,
        [2, 0] => 10, [2, 1] => 1, [2, 2] => 0
      }
    end
    it 'returns index with min ranking' do
      expect(perform(data, 3, 2)).to eq([2, 1])
    end
  end
end
