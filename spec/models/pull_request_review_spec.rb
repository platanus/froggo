require 'rails_helper'

RSpec.describe PullRequestReview, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:pull_request) }
    it { is_expected.to belong_to(:github_user) }
  end
end
