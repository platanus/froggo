require 'rails_helper'

RSpec.describe ImportPullRequestsJob, type: :job do
  describe "#perform" do
    let(:repository) { double }
    let(:page) { 1 }
    let(:token) { 'token' }
    let(:perform_now) { ImportPullRequestsJob.perform_now(repository, page, token) }

    it "calls GithubPullRequestService#import_page_from_repository" do
      expect_any_instance_of(GithubPullRequestService).to receive(:import_page_from_repository)
        .with(repository, page).and_return(nil)

      perform_now
    end
  end
end
