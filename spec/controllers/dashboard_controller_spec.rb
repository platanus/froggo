require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET #index" do
    subject { get :index }

    it "returns should have success status code" do
      expect(subject).to have_http_status(200)
    end

    it "renders the index template" do
      expect(subject).to render_template(:index)
      expect(subject).to render_template("index")
      expect(subject).to render_template("dashboard/index")
    end

    it "does not render a different template" do
      expect(subject).to_not render_template("admin")
    end
  end
end
