require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    let(:valid) { true }
    let!(:github_session) do
      double(name: 'login', token: 'token', valid?: valid, froggo_path: 'path')
    end
    before do
      allow(subject).to receive(:github_session).and_return(github_session)
      get :index
    end

    context "when user is not authenticated" do
      let(:valid) { false }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is authenticated" do
      let(:valid) { true }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
