require 'rails_helper'

RSpec.describe PullRequestReview, type: :model do
  describe 'relationships' do
    it { should belong_to(:pull_request) }
    it { should belong_to(:github_user) }
  end

  describe 'on save' do
    let!(:pull_request) { create(:pull_request) }
    it 'touches pull request' do
      expect do
        create(:pull_request_review, pull_request: pull_request)
        pull_request.reload
      end.to(change { pull_request.last_pull_req_review_modification })
    end
  end
end
