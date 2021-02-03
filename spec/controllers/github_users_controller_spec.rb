require 'rails_helper'

RSpec.describe GithubUsersController, type: :controller do
  let(:user) { create(:github_user, login: "user_login") }
  let(:platanus_org) { create(:organization, login: "platanus", members: [user]) }
  let(:github_session) { instance_double("GithubSession") }

  before do
    allow(github_session).to receive(:token).and_return("token")
    allow(github_session).to receive(:organizations).and_return(
      [{ id: platanus_org.gh_id, role: "member" }]
    )
    allow(github_session).to receive(:user).and_return(user)
    allow(controller).to receive(:github_session).and_return(github_session)
    allow(controller).to receive(:authenticate_github_user).and_return(true)
  end

  describe '#GET /me' do
    it 'returns redirect status' do
      get :me, params: { github_user: user, github_session: github_session }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe '#GET /users/:id' do
    it 'returns success status' do
      get :show, params: { id: user.id, github_session: github_session }
      expect(response).to have_http_status(:success)
    end
  end
end
