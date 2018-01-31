require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'includes the correct concerns' do
    it { expect(described_class.ancestors.include?(GithubAuthenticable)).to eq(true) }
  end
end
