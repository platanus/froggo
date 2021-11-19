require 'rails_helper'

RSpec.describe Api::V1::FroggoTeamMembershipsController, type: :controller do
  let(:user) { create(:github_user, login: "platanus_user") }
  let(:organization) { create(:organization, login: "platanus", members: [user]) }
  let(:team) { create(:froggo_team, name: "platanus_team", organization: organization) }
  let(:membership) do
    create(:froggo_team_membership, github_user: user, froggo_team: team)
  end
  let(:github_session) { instance_double("GithubSession") }

  before do
    allow(github_session).to receive(:token).and_return("token")
    allow(github_session).to receive(:organizations).and_return(
      [{ id: organization.gh_id, role: "member" }]
    )
    allow(github_session).to receive(:user).and_return(user)
    allow(controller).to receive(:authenticate_github_user).and_return(true)
    allow(GithubSession).to receive(:new).and_return(github_session)
  end

  describe '#index' do
    it 'responds with ok' do
      get :index, params: { github_user_id: user.id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    context 'when user is from other organization' do
      before do
        allow(controller).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
        patch :update, params: { id: membership.id, is_member_active: false }, format: :json
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when user is from the same organization' do
      before do
        allow(controller).to receive(:authorize)
        patch :update, params: { id: membership.id, is_member_active: false }, format: :json
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe '#update_all' do
    before do
      patch :update_all, params: { github_user_id: user.id, is_member_active: false }, format: :json
    end

    it 'responds with ok' do
      expect(response).to have_http_status(:ok)
    end
  end
end
