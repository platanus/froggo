require 'rails_helper'

RSpec.describe Api::V1::GithubUsersController, type: :controller do
  let(:github_session) { instance_double("GithubSession") }

  before do
    allow(GithubSession).to receive(:new).and_return(github_session)
  end

  describe '#current' do
    context 'when user is logged in' do
      let(:user) { create(:github_user, login: "user_login") }

      before do
        allow(github_session).to receive(:valid?).and_return(true)
        allow(github_session).to receive(:user).and_return(user)
        get :logged_user, format: :json
      end

      it 'responds with current logged user' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(user.id)
      end
    end

    context 'when user is not logged in' do
      before do
        allow(github_session).to receive(:valid?).and_return(false)
        get :logged_user, format: :json
      end

      it 'responds with landing page' do
        expect(response).to have_http_status(:found)
      end
    end
  end
end
