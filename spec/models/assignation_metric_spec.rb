require 'rails_helper'

RSpec.describe AssignationMetric, type: :model do
  it 'has a valid factory' do
    expect(build(:assignation_metric)).to be_valid
  end

  describe 'validations' do
    subject { FactoryBot.build(:assignation_metric) }

    it { is_expected.to validate_presence_of :from }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:github_user) }
    it { is_expected.to belong_to(:pull_request) }
  end
end
