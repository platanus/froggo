require 'rails_helper'

RSpec.describe PullRequestsController, type: :controller do
  describe "GET #index" do
    let(:organization1) { create(:organization, login: 'my_organization') }
    let(:organization2) { create(:organization, login: 'other_organization') }
    let(:repo1) { create(:repository, organization: organization1) }
    let(:repo2) { create(:repository, organization: organization2) }
    let!(:pr1) { create(:pull_request, repository: repo1) }
    let!(:pr2) { create(:pull_request, repository: repo2) }

    before { get :index, params: { organization_name: organization1.login } }

    it { expect(response).to have_http_status(:success) }

    it do
      expect(assigns(:pull_requests)).to contain_exactly(pr1)
    end
  end
end
