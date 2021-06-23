require 'rails_helper'

RSpec.describe Api::V1::PreferencesController, type: :controller do
  let!(:user1) { create(:github_user, login: "user_login") }
  let!(:user2) { create(:github_user, login: "user_login2") }
  let(:github_session) { instance_double("GithubSession") }
  let(:preference1) { create(:preference, github_user: user1) }
  let(:preference2) { create(:preference, github_user: user2) }

  before do
    allow(github_session).to receive(:token).and_return("token")
    allow(github_session).to receive(:user).and_return(user1)
    allow(GithubSession).to receive(:new).and_return(github_session)
    allow(preference1).to receive(:id).and_return(preference1)
    allow(preference2).to receive(:id).and_return(preference2)
  end

  describe "GET #show" do
    context 'when id is the same as logged user id' do
      before do
        get :show, params: { id: user1.id }, format: :json
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'when id is not the logged user id' do
      before do
        get :show, params: { id: user2.id }, format: :json
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe "PATCH #update" do
    context 'when updating logged user preferences' do
      before do
        patch :update, params: {  id: user1.id, default_organization_id: 2, default_team_id: 3,
                                  default_time: "one_month" }, format: :json
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'when updating other user preferences' do
      before do
        patch :update, params: {  id: user2.id, default_organization_id: 2, default_team_id: 3,
                                  default_time: "one_month" }, format: :json
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
