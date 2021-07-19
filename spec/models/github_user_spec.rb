require 'spec_helper'

RSpec.describe GithubUser, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :gh_id }
    it { is_expected.to validate_presence_of :login }
  end

  describe 'relationships' do
    it { is_expected.to have_many(:pull_requests) }
    it { is_expected.to have_many(:pull_request_reviews) }
    it { is_expected.to have_one(:preference) }
    it { is_expected.to have_many(:assignation_metrics).dependent(:destroy) }
  end
end
