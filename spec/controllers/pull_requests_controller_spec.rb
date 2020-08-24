require 'rails_helper'

RSpec.describe PullRequestsController, type: :controller do
  describe "GET #index" do
    let(:organization1) { create(:organization, login: 'my_organization') }
    let(:organization2) { create(:organization, login: 'other_organization') }
    let(:repo1) { create(:repository, organization: organization1) }
    let(:repo2) { create(:repository, organization: organization2) }
    let!(:pr1) { create(:pull_request, repository: repo1) }
    let!(:pr2) { create(:pull_request, repository: repo2) }
    let!(:user1) { create(:github_user, login: "user_login") }
    let!(:github_session) { instance_double("GithubSession") }

    before do
      allow(github_session).to receive(:token).and_return("token")
      allow(github_session).to receive(:user).and_return(user1)
      expect(subject).to receive(:authenticate_github_user).and_return(true)
      allow(subject).to receive(:github_session).and_return(github_session)
      get :index, params: { organization_name: organization1.login, github_user: user1 }
    end

    it { expect(response).to have_http_status(:success) }

    it do
      expect(assigns(:pull_requests)).to contain_exactly(pr1)
    end
  end
end
