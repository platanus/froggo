require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    let(:user) { create(:github_user) }
    let(:github_session) { double(:github_session) }

    before do
      allow(subject).to receive(:github_session).and_return(github_session)
    end

    context "when user is authenticated" do
      before do
        allow(github_session).to receive(:valid?) { true }
        allow(github_session).to receive(:user) { user }
      end

      it do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not authenticated" do
      before { allow(github_session).to receive(:valid?) { false } }

      it do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
