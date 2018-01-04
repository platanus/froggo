require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET #index" do
    let (:client) { double }
    subject { get :index, session: { 'access_token' => 3 } }

    before do
      allow(OctokitClient).to receive(:client).and_return(client)
    end

    context "when user exists" do
      before do
        allow(client).to receive(:new).with(
          access_token: ''
        ).and_return('')
      end

      it "returns should have success status code" do
        allow(client).to receive(:user).and_return('login': '')
        expect(subject).to have_http_status(200)
      end

      it "renders the index template" do
        allow(client).to receive(:user).and_return('login': '')
        expect(subject).to render_template(:index)
        expect(subject).to render_template("index")
        expect(subject).to render_template("dashboard/index")
      end

      it "does not render a different template" do
        allow(client).to receive(:user).and_return('login': '')
        expect(subject).to_not render_template("admin")
      end
    end
  end
end
