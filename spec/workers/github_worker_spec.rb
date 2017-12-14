require 'rails_helper'
RSpec.describe GithubWorker, type: :worker do
  describe "FETCH_ORG_REPOS" do
    let(:organization) { create(:organization) }

    before do
      allow_any_instance_of(GithubService).to receive(:create_organization_repositories)
        .with(organization.name).and_return(nil)
    end

    before :each do
      Sidekiq::Worker.clear_all
    end

    it "adds worker to queue" do
      expect do
        GithubWorker.perform_async("FETCH_ORG_REPOS", organization_id: organization.id)
      end.to change(GithubWorker.jobs, :size).by(1)
    end

    it "calls GithubService" do
      expect_any_instance_of(GithubService).to(
        receive(:create_organization_repositories)
      )

      GithubWorker.perform_async("FETCH_ORG_REPOS", organization_id: organization.id)
      GithubWorker.drain
    end
  end
end
