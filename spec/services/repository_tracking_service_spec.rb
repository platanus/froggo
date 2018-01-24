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
        create_list(:pull_request_with_reviews, 2, reviews_count: 3, repository: repository)
      end

      it "ends with no pull requests" do
        expect { service.track }.to change { PullRequest.count }.from(2).to(0)
      end

      it "ends with no pull request reviews" do
        expect { service.track }.to change { PullRequestReview.count }.from(6).to(0)
      end
    end

    it "change repository tracked status" do
      expect { service.track }.to change { repository.tracked }.from(false).to(true)
    end
  end
end
