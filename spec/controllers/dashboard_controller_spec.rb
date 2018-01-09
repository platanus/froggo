require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET #index" do
    let (:client) { double }
    subject { get :index, session: { 'access_token' => 3 } }

    before do
      allow(Octokit::Client).to receive(:new).and_return(client)
    end

    context "when user exists" do
      before do
        cookies['orgs'] = 'something&else'
        allow(client).to receive(:user).with(
          access_token: 3
        ).and_return('login': '')
        DashboardController.any_instance.stub(:set_organizations_cookie).and_return([['something', 'something']])
      end

      it "returns should have found status code" do
        allow(client).to receive(:user).and_return('login': '')
        expect(subject).to have_http_status(302)
      end

      it "renders the index template" do
        allow(client).to receive(:user).and_return('login': '')
        expect(subject).to redirect_to('/dashboard/something')
      end

      it "does not render a different template" do
        allow(client).to receive(:user).and_return('login': '')
        expect(subject).to_not render_template("admin")
      end
    end
  end
end
