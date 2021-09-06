require 'rails_helper'

RSpec.describe Api::V1::GithubUsersController, type: :controller do
  let(:github_session) { instance_double("GithubSession") }

  before do
    allow(GithubSession).to receive(:new).and_return(github_session)
    allow(github_session).to receive(:valid?).and_return(true)
    allow(github_session).to receive(:user).and_return(user)
  end

  describe '#froggo_team_users' do
    context 'when user is logged in' do
      let(:user) { create(:github_user, login: "user_login") }
      let(:organization) { create(:organization, login: "platanus", members: [user]) }
      let!(:froggo_team) { create(:froggo_team, name: "test", organization: organization) }

      before do
        FroggoTeamMembership.create!(github_user: user, froggo_team: froggo_team)
        get :froggo_team_users, format: :json, params: { froggo_team_id: froggo_team.id }
      end

      it 'expects to return the users of the team' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data'].first['id']).to eq(user.id.to_s)
      end
    end
  end

  describe '#current' do
    context 'when user is logged in' do
      let(:user) { create(:github_user, login: "user_login") }

      before do
        get :logged_user, format: :json
      end

      it 'responds with current logged user' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(user.id)
      end
    end

    context 'when user is not logged in' do
      let(:user) { nil }

      before do
        allow(github_session).to receive(:valid?).and_return(false)
        get :logged_user, format: :json
      end

      it 'responds with landing page' do
        expect(response).to have_http_status(:found)
      end
    end
  end
end
