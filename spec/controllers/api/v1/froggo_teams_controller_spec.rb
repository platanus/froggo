require 'rails_helper'

RSpec.describe Api::V1::FroggoTeamsController, type: :controller do
  let(:user) { create(:github_user, login: "user_login") }
  let(:platanus_org) { create(:organization, login: "platanus", members: [user]) }
  let!(:p_team) { create(:froggo_team, name: "test_name", organization: platanus_org) }
  let(:new_team) { create(:froggo_team, name: "test_name2", organization: platanus_org) }
  let(:buda_org) { create(:organization) }
  let!(:buda_team) { create(:froggo_team, name: "test_name", organization: buda_org) }
  let(:user_1) { create(:github_user, login: "user1_login") }
  let!(:join) { create(:froggo_team_membership, github_user: user_1, froggo_team: p_team) }
  let(:github_session) { instance_double("GithubSession") }

  before do
    allow(github_session).to receive(:token).and_return("token")
    allow(github_session).to receive(:organizations).and_return(
      [{ id: platanus_org.gh_id, role: "member" }]
    )
    allow(github_session).to receive(:user).and_return(user)

    expect(subject).to receive(:authenticate_github_user).and_return(true)
    allow(subject).to receive(:github_session).and_return(github_session)
  end

  describe '#index' do
    it 'responds with ok' do
      get :index, params: { organization_id: platanus_org.id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    let(:organization) { platanus_org }

    context "when creator user is not from organization" do
      let(:organization) { buda_org }

      before do
        post :create, params: { name: "test_name", organization_id: buda_org.id }, format: :json
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when name already exists for organization" do
      before do
        post :create, params: { name: "test_name", organization_id: platanus_org.id }, format: :json
      end

      it { expect(response).to have_http_status(:bad_request) }
    end

    context "when everything is ok" do
      before do
        post :create, params: { name: "name", organization_id: platanus_org.id, new_members_ids: [user.id] }, format: :json
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe '#show' do
    it 'responds with ok' do
      get :show, params: { id: p_team.id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    context "when updater user is not from organization" do
      before do
        patch :update, params: { id: buda_team.id, name: "test_name" }, format: :json
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when the name is already taken" do
      before do
        patch :update, params: { id: p_team.id, name: "test_name" }, format: :json
      end

      it { expect(response).to have_http_status(:bad_request) }
    end

    context "when everything is ok" do
      before do
        patch :update, params: { id: p_team.id, name: "new_name" }, format: :json
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe '#destroy' do
    context "when destroyer user is not from organization" do
      before do
        delete :destroy, params: { id: buda_team.id }, format: :json
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when the team was succesfuly destroyed" do
      before do
        delete :destroy, params: { id: new_team.id }, format: :json
      end

      it { expect(response).to have_http_status(:no_content) }
    end
  end
end
