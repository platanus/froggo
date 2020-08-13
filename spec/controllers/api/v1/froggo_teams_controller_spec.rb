require 'rails_helper'

RSpec.describe Api::V1::FroggoTeamsController, type: :controller do
  let(:user) { create(:github_user) }
  let(:platanus_org) { create(:organization, login: "platanus", members: [user]) }
  let!(:platanus_team) { create(:froggo_team, name: "test_name", organization: platanus_org) }
  let(:buda_org) { create(:organization) }
  let!(:buda_team) { create(:froggo_team, name: "test_name", organization: buda_org) }
  let(:github_session) do
    double(
      token: "token",
      organizations: [{ id: platanus_org.gh_id, role: "member" }],
      user: user
    )
  end

  before do
    expect(subject).to receive(:authenticate_github_user).and_return(true)
    allow(subject).to receive(:github_session).and_return(github_session)
  end

  describe '#index' do
    it 'responds with ok' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
    let(:organization) { platanus_org }

    context "when creator user is not from organization" do
      let(:organization) { buda_org }

      before do
        post :create, params: { name: "test_name", org_id: buda_org.id }, format: :json
      end

      it { expect(response).to have_http_status(400) }
    end

    context "when name already exists for organization" do
      before do
        post :create, params: { name: "test_name", org_id: platanus_org.id }, format: :json
      end

      it { expect(response).to have_http_status(400) }
    end

    context "when everything is ok" do
      before do
        post :create, params: { name: "new_name", org_id: platanus_org.id }, format: :json
      end

      it { expect(response).to have_http_status(200) }
    end
  end

  describe '#show' do
    it 'responds with ok' do
      get :show, params: { id: platanus_team.id }, format: :json
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    context "when updater user is not from organization" do
      before do
        patch :update, params: { id: buda_team.id, name: "test_name" }, format: :json
      end

      it { expect(response).to have_http_status(400) }
    end

    context "when the name is already taken" do
      before do
        patch :update, params: { id: platanus_team.id, name: "test_name" }, format: :json
      end

      it { expect(response).to have_http_status(400) }
    end

    context "when everything is ok" do
      before do
        patch :update, params: { id: platanus_team.id, name: "new_name" }, format: :json
      end

      it { expect(response).to have_http_status(200) }
    end
  end

  describe '#destroy' do
    context "when destroyer user is not from organization" do
      before do
        delete :destroy, params: { id: buda_team.id }, format: :json
      end

      it { expect(response).to have_http_status(400) }
    end

    context "when the team was succesfuly destroyed" do
      before do
        delete :destroy, params: { id: platanus_team.id }, format: :json
      end

      it { expect(response).to have_http_status(204) }
    end
  end
end
