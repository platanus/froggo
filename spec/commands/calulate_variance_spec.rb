require 'rails_helper'

describe CalulateVariance do
  def perform(data, size, limit)
    described_class.for(data: data, size: size, limit: limit)
  end

  context 'calculate min variance' do
    let(:data) do
      {
        [0, 0] => 0, [0, 1] => 20, [0, 2] => 1,
        [1, 0] => 10, [1, 1] => 0, [1, 2] => 2,
        [2, 0] => 4, [2, 1] => 0, [2, 2] => 1
      }
    end
    it 'returns index with min variance' do
      expect(perform(data, 3, 2)).to eq([2, 0])
    end
  end
end
