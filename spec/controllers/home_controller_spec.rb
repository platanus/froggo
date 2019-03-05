require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    let(:user) { create(:github_user) }
    let(:valid) { true }
    let(:github_session) { double(:github_session, valid?: valid) }

    before do
      allow(subject).to receive(:github_session).and_return(github_session)
    end

    context "when user is authenticated" do
      before do
        allow(github_session).to receive(:user) { user }
        get :index
      end

      it { expect(response).to have_http_status(302) }
    end

    context "when user is not authenticated" do
      let(:valid) { false }

      before { get :index }

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:request_login_url)).to eq(github_authenticate_path) }
    end
  end
end
