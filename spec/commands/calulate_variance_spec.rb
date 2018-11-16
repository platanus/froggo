require 'rails_helper'

describe CalulateVariance do
  def perform(data, size)
    described_class.for(data: data, size: size)
  end

  context 'calculate min variance' do
    let(:data) do
      {
        [0, 1] => 10, [0, 2] => 10, [0, 0] => 0,
        [1, 0] => 0, [1, 2] => 20, [1, 1] => 0,
        [2, 0] => 1, [2, 1] => 1, [2, 2] => 1
      }
    end
    it 'returns index with min variance' do
      expect(perform(data, 3)).to eq(2)
    end
  end
end
