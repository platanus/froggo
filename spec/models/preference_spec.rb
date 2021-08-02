require 'rails_helper'

RSpec.describe Preference, type: :model do
  it 'has a valid factory' do
    expect(build(:preference)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :default_organization_id }
    it { is_expected.to validate_presence_of :default_team_id }
    it { is_expected.to validate_presence_of :default_time }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:github_user) }
  end
end
