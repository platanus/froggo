require 'rails_helper'

RSpec.describe Api::V1::LikesController, type: :controller do
  describe "POST #create" do
    let(:organization1) { create(:organization, login: 'my_organization') }
    let(:organization2) { create(:organization, login: 'other_organization') }
    let(:repo1) { create(:repository, organization: organization1) }
    let(:repo2) { create(:repository, organization: organization2) }
    let(:pr1) { create(:pull_request, repository: repo1) }
    let(:pr2) { create(:pull_request, repository: repo2) }
    let(:user1) { create(:github_user, login: "user_login") }
    let!(:user2) { create(:github_user, login: "user_login2") }
    let!(:like1) { create(:like, github_user: user1, likeable: pr1) }
    let(:github_session) { instance_double("GithubSession") }

    before do
      allow(github_session).to receive(:token).and_return("token")
      allow(github_session).to receive(:user).and_return(user1)
      allow(subject).to receive(:github_session).and_return(github_session)
      post :create, params: { github_user: user1, likeable: pr2,
                              pull_request_id: pr2.id }, format: :json
    end

    it { expect(response).to have_http_status(:success) }

    it do
      expect(assigns(:pull_request)).to eq(pr2)
    end
  end
end
