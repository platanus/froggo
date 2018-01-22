require 'rails_helper'

describe BuildOctokitClient do
  let!(:response) { double(auto_paginate: true) }
  let(:token) { 'XXX' }

  def perform(*_args)
    described_class.for(token: token)
  end

  context 'build client' do
    it 'performs client creation' do
      expect(Octokit::Client).to receive(:new)
        .with(access_token: "XXX").and_return(response)
      expect(response).to receive(:auto_paginate=)
        .with(true).and_return(nil)
      expect(perform).to eq(response)
    end
  end
end
