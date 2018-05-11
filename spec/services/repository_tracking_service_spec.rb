require 'rails_helper'

describe RepositoryTrackingService do
  let(:token) { "blubli" }
  let(:repository) { create(:repository) }

  let(:service) { build(repository: repository, token: token) }

  def build(*_args)
    described_class.new(*_args)
  end

  describe "#track" do
    context "when repository is already tracked" do
      before do
        repository.update(tracked: true)
        expect_any_instance_of(GithubPullRequestService).not_to receive(:import_all_from_repository)
          .with(repository).and_return(true)

        expect_any_instance_of(GithubRepositoryService).not_to receive(:set_webhook)
          .with(repository).and_return(true)
      end

      it "doesn't call the services" do
        service.track
      end

      it "doesn't change repository tracked status" do
        expect { service.track }.not_to(change { repository.tracked })
      end
    end

    context "when repository is untracked" do
      before do
        expect_any_instance_of(GithubPullRequestService).to receive(:import_all_from_repository)
          .with(repository).and_return(true)

        expect_any_instance_of(GithubRepositoryService).to receive(:set_webhook)
          .with(repository).and_return(true)
      end

      it "change repository tracked status" do
        expect { service.track }.to change { repository.tracked }.from(false).to(true)
      end

      context "PR exists and no PR where imported" do
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
    end
  end

  describe "#untrack" do
    context "when repository is tracked" do
      before do
        repository.tracked = true

        expect_any_instance_of(GithubRepositoryService).to receive(:remove_webhook)
          .with(repository).and_return(true)
      end

      it "change repository tracked status" do
        expect { service.untrack }.to change { repository.tracked }.from(true).to(false)
      end

      context "with pull request and reviews" do
        before do
          create_list(:pull_request_with_reviews, 2, reviews_count: 3, repository: repository)
          service.untrack
        end

        it { expect(repository.pull_requests.count).to eq(0) }
        it { expect(repository.pull_request_reviews.count).to eq(0) }
      end
    end

    context "when repository is already untracked" do
      before do
        expect_any_instance_of(GithubRepositoryService).not_to receive(:remove_webhook)
          .with(repository).and_return(true)
      end

      it "doesn't calls services" do
        service.untrack
      end

      it "change repository tracked status" do
        expect { service.untrack }.not_to(change { repository.tracked })
      end
    end
  end
end
