require 'rails_helper'

describe RepositoryTrackingService do
  let(:token) { "blubli" }
  let(:repository) { create(:repository) }

  let(:service) { build(repository: repository, token: token) }

  def build(*_args)
    described_class.new(*_args)
  end

  before do
    expect_any_instance_of(GithubPullRequestService).to receive(:import_all_from_repository)
      .and_return(true)

    expect_any_instance_of(GithubPullRequestReviewService).to receive(:import_all_from_repository)
      .and_return(true)
  end

  describe "#track" do
    context "when PR exists and no PR where imported" do
      before do
        pullrequest1 = create(:pull_request, repository: repository)
        pullrequest2 = create(:pull_request, repository: repository)
        create(:pull_request_review, pull_request: pullrequest1)
        create(:pull_request_review, pull_request: pullrequest1)
        create(:pull_request_review, pull_request: pullrequest2)
      end

      it "ends with no pull requests" do
        expect { service.track }.to change { PullRequest.count }.from(2).to(0)
      end

      it "ends with no pull request reviews" do
        expect { service.track }.to change { PullRequestReview.count }.from(3).to(0)
      end
    end

    it "change repository tracked status" do
      expect { service.track }.to change { repository.tracked }.from(false).to(true)
    end
  end
end
