require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  before do
    expect(subject).to receive(:authenticate_github_user).and_return(true)
    allow(subject).to receive(:github_session).and_return(github_session)
  end

  describe "GET #index" do
    let(:github_organizations) do
      [
        { login: 'platanus' },
        { login: 'huevapi' }
      ]
    end

    context "when ser does not belongs to any organizations" do
      let(:github_session) { double(organizations: []) }

      before do
        get :index
      end

      it { expect(response).to redirect_to('/organizations/missing') }
    end

    context "when user belongs to at least one organization, but no organization is selected" do
      let(:github_session) { double(organizations: github_organizations) }

      before do
        get :index
      end

      it 'redirects to first organization organization' do
        expect(response).to redirect_to('/organizations/platanus')
      end
    end

    context "when user belongs the selected organization" do
      let(:github_session) { double(organizations: github_organizations) }

      before do
        get :index, params: { name: github_organizations.first[:login] }
      end

      it { expect(assigns(:organization)).to eq(github_organizations.first) }
    end
  end

  describe "GET #settings" do
    let(:github_session) do
      double(
        organizations: [login: "platanus", role: role]
      )
    end

    before do
      get :settings, params: { name: "platanus" }
    end

    context "when user is admin" do
      let(:role) { "admin" }

      it { expect(response).to have_http_status(200) }
    end

    context "when user is admin" do
      let(:role) { "member" }

      it { expect(response).to redirect_to('/organizations/platanus') }
    end
  end
end
