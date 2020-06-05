require 'rails_helper'

RSpec.describe PullRequestReviewRequest, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:pull_request) }
    it { is_expected.to belong_to(:github_user).optional(true) }
  end
end
