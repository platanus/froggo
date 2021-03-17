require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  before do
    allow(subject).to receive(:github_session).and_return(github_session)
  end

  let(:github_organizations) do
    [
      { id: 101, login: 'platanus' },
      { id: 102, login: 'huevapi' }
    ]
  end

  let(:user) { create(:github_user) }

  describe "GET #index" do
    before do
      expect(subject).to receive(:authenticate_github_user).and_return(true)
    end

    context "when user does not belongs to any organizations" do
      let(:github_session) { double(organizations: [], name: 'name', save_froggo_path: 'path') }

      before do
        get :index
      end

      it { expect(response).to redirect_to('/organizations/missing') }
    end

    context "when user belongs to at least one organization, but no organization is selected" do
      let(:github_session) do
        double(organizations: github_organizations, name: 'name', save_froggo_path: 'path')
      end

      before do
        get :index
      end

      it 'redirects to first organization' do
        expect(response).to redirect_to('/organizations/platanus')
      end
    end
  end

  describe "#show" do
    let(:github_session) do
      instance_double('GithubSession', organizations: github_organizations,
                                       save_froggo_path: 'path')
    end

    before do
      allow(github_session).to receive(:user).and_return(user)
      allow(github_session).to receive(:valid?).and_return(true)
    end

    context "when user belongs to the selected organization" do
      before do
        get :show, params: { name: "platanus" }
      end

      it { expect(assigns(:github_organization)).to eq(github_organizations.first) }
    end

    context "when user does not belong to the selected organization" do
      before do
        get :show, params: { name: "tesla" }
      end

      it { expect(response).to redirect_to('/organizations') }
    end

    context "when organization exists locally" do
      before do
        org_teams = [{ id: 1, name: 'Core', slug: 'core' },
                     { id: 2, name: 'Extra', slug: 'extra' }]
        allow(github_session).to receive(:get_teams).with(organization) { org_teams }
      end
      let!(:organization) { create(:organization, gh_id: 101) }

      before do
        get :show, params: { name: "platanus" }
      end

      it { expect(assigns(:organization)).to eq(organization) }
    end

    context "when organization does not exist locally" do
      before do
        get :show, params: { name: "platanus" }
      end

      it { expect(assigns(:organization)).to be_nil }
    end
  end

  describe "GET #settings" do
    before do
      expect(subject).to receive(:authenticate_github_user).and_return(true)
    end

    let!(:github_session) do
      double(
        session: { client_type: "admin" },
        organizations: [login: "platanus", role: role, id: 101],
        name: 'name',
        save_froggo_path: 'path'
      )
    end

    let!(:organization) { create(:organization, gh_id: 101, default_team_id: nil) }

    before do
      allow(github_session).to receive(:get_teams).and_return([])
      allow(github_session).to receive(:user) { user }
      get :settings, params: { name: "platanus" }
    end

    context "when user is admin" do
      let(:role) { "admin" }

      it { expect(response).to have_http_status(200) }
    end

    context "when user is member" do
      let(:role) { "member" }

      it { expect(response).to redirect_to('/organizations/platanus') }
    end
  end
end
