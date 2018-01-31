require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
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

      it { expect(response).to redirect_to('/dashboard/missing_organizations') }
    end

    context "when user belongs to at least one organization, but no organization is selected" do
      let(:github_session) { double(organizations: github_organizations) }

      before do
        get :index
      end

      it 'redirects to first organization dashboard' do
        expect(response).to redirect_to('/dashboard/platanus')
      end
    end

    context "when user belongs the selected organization" do
      let(:github_session) { double(organizations: github_organizations) }

      before do
        get :index, params: { gh_org: github_organizations.first[:login] }
      end

      it { expect(assigns(:organization)).to eq(github_organizations.first) }
    end
  end
end
