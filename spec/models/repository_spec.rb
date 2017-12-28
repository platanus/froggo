require 'rails_helper'

RSpec.describe Repository, type: :model do
  describe "validations" do
    it { should validate_presence_of :gh_id }
    it { should validate_presence_of :full_name }
  end

  describe 'default values' do
    let!(:repo) { create(:repository) }
    it 'sets value to last_pull_request_modification' do
      expect(repo.last_pull_request_modification).to_not be_nil
    end
  end
end
