require 'rails_helper'

RSpec.describe WebhookController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #receive" do
    it "returns http success" do
      post :receive
      expect(response).to have_http_status(:success)
    end
  end
end
