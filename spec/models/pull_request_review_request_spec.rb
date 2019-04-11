require 'rails_helper'

RSpec.describe PullRequestReviewRequest, type: :model do
  describe 'relationships' do
    it { should belong_to(:pull_request) }
    it { should belong_to(:github_user) }
  end
end
