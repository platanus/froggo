require 'rails_helper'

describe GithubPullRequestReviewService do
  let(:token) { "blubli" }
  let(:pull_request) { create(:pull_request, repository: repository) }

  let(:service) { build(token: token) }

  let!(:github_review_response) do
    double(
      id: 123,
      user: double(
        id: 1,
        login: "milla",
        name: "Milla Jovovich",
        email: "milla@jovovich.cl",
        avatar_url: 'url_to_avatar',
        html_url: 'url_to_html'
      )
    )
  end

  def build(*_args)
    described_class.new(*_args)
  end

  describe "#import_github_pull_request_review" do
    context "when repository is not tracked" do
      let(:repository) { create(:repository, tracked: false) }

      it "doesn't create any reviews" do
        expect do
          service.import_github_pull_request_review(pull_request, github_review_response)
        end.to(change { PullRequestReview.count }.by(0))
      end
    end

    context "when repository is tracked" do
      let(:repository) { create(:repository, tracked: true) }

      context "and review doesn't exist" do
        it "creates new pull request review" do
          expect do
            service.import_github_pull_request_review(pull_request, github_review_response)
          end.to(change { PullRequestReview.count }.by(1))
        end

        it "creates a pull request review with valid data" do
          service.import_github_pull_request_review(pull_request, github_review_response)
          pull_request_review = PullRequestReview.last

          expect(pull_request_review).to have_attributes(
            gh_id: 123,
            github_user_id: GithubUser.find_by(gh_id: 1).id
          )
        end
      end

      context "and review exists" do
        before do
          create(:pull_request_review, gh_id: 123, pull_request: pull_request)
        end

        it "does not create new pull request reviews" do
          expect do
            build(token: token).import_github_pull_request_review(pull_request,
              github_review_response)
          end.not_to(change { PullRequestReview.count })
        end
      end
    end
  end

  describe "#import_all_from_repository" do
    let(:repository) { create(:repository, tracked: true) }
    it "calls import_all_from_pull_request" do
      expect(ImportPullRequestReviewsJob).to receive(:perform_later)
        .with(pull_request, token)
        .and_return(nil)

      service.import_all_from_repository(repository)
    end
  end

  describe "#import_all_from_pull_request" do
    let(:client) { double(:client, pull_requests: true) }
    let(:repository) { create(:repository, tracked: true) }

    before do
      allow(BuildOctokitClient).to receive(:for).with(token: token).and_return(client)

      allow(client).to receive(:pull_request_reviews)
        .with(repository.full_name, 1, accept: 'application/vnd.github.thor-preview+json')
        .and_return([github_review_response])
    end

    it "calls import_github_pull_request_review" do
      expect(service).to receive(:import_github_pull_request_review)
        .with(pull_request, github_review_response)
        .and_return(nil)

      service.import_all_from_pull_request(pull_request)
    end
  end

  describe "#handle_webhook_event" do
    let(:repository) { create(:repository, tracked: true) }
    let!(:event_request_data) do
      double(
        action: 'submitted',
        review: github_review_response,
        pull_request: double(id: pull_request.gh_id)
      )
    end

    it "calls import_github_pull_request_review" do
      expect(service).to receive(:import_github_pull_request_review)
        .with(pull_request, github_review_response)
        .and_return(nil)
      service.handle_webhook_event(event_request_data)
    end
  end

  describe '#delete_prs_reviews' do
    context 'with no reviews to delete' do
      let!(:pr_ids) { [] }
      it "doesn't delete any pull request review" do
        expect { service.delete_prs_reviews(pr_ids) }.to change { PullRequestReview.count }.by(0)
      end
    end

    context 'with only one review to delete' do
      let!(:gh_ids) { [10] }
      let(:pull_request1) { create(:pull_request, gh_id: gh_ids[0]) }
      let!(:pr_ids) { [pull_request1.id] }
      let!(:pr_review) do
        create(:pull_request_review, gh_id: 1, pull_request: pull_request1)
      end

      it 'deletes pull request review' do
        expect { service.delete_prs_reviews(pr_ids) }.to change { PullRequestReview.count }.by(-1)
      end
    end

    context 'with more than one review to delete' do
      let!(:gh_ids) { [10, 20, 30] }
      let(:pull_request1) { create(:pull_request, gh_id: gh_ids[0]) }
      let(:pull_request2) { create(:pull_request, gh_id: gh_ids[1]) }
      let(:pull_request3) { create(:pull_request, gh_id: gh_ids[2]) }
      let!(:pr_ids) { [pull_request1.id, pull_request2.id, pull_request3.id] }
      let!(:pr_review) do
        create(:pull_request_review, gh_id: 1, pull_request: pull_request1)
      end

      let!(:pr_review2) do
        create(:pull_request_review, gh_id: 2, pull_request: pull_request2)
      end

      let!(:pr_review3) do
        create(:pull_request_review, gh_id: 3, pull_request: pull_request3)
      end

      it 'deletes all pull requests reviews' do
        expect { service.delete_prs_reviews(pr_ids) }.to change { PullRequestReview.count }.by(-3)
      end
    end
  end
end
