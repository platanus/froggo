require 'rails_helper'

RSpec.describe Api::V1::PullRequestReviewersController, type: :controller do
  describe '# POST /api/v1/pull_request_reviewer/add' do
    it 'returns found status' do
      post :add_reviewer
      expect(response).to have_http_status(:found)
    end
  end
end
