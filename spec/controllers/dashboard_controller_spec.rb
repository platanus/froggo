require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET #index" do
    it "returns should have success" do
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
