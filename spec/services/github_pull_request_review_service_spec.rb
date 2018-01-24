require 'rails_helper'

describe GithubPullRequestReviewService do
  let(:token) { "blubli" }
  let(:repository) { create(:repository) }
  let(:pull_request) { create(:pull_request, repository: repository) }

  let(:service) { build(token: token) }

  let!(:github_reviews_response) do
    [
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
    ]
  end

  let(:client) { double(:client, pull_requests: true) }

  def build(*_args)
    described_class.new(*_args)
  end

  before do
    allow(BuildOctokitClient).to receive(:for).with(token: token).and_return(client)

    allow(client).to receive(:pull_request_reviews)
      .with(repository.full_name, 1, accept: 'application/vnd.github.thor-preview+json')
      .and_return(github_reviews_response)
  end

  describe "#import_all_from_pull_request" do
    context "when review doesn`t exist" do
      it "creates new pull request review" do
        expect { service.import_all_from_pull_request(pull_request) }.to(
          change { PullRequestReview.count }.by(1)
        )
      end

      it "creates a pull request review with valid data" do
        service.import_all_from_pull_request(pull_request)
        pull_request_review = PullRequestReview.last

        expect(pull_request_review).to have_attributes(
          gh_id: 123,
          github_user_id: GithubUser.find_by(gh_id: 1).id
        )
      end
    end

    context "when review exists" do
      before do
        create(:pull_request_review, gh_id: 123, pull_request: pull_request)
      end

      it "does not create new pull request reviews" do
        expect { build(token: token).import_all_from_pull_request(pull_request) }.not_to(
          change { PullRequestReview.count }
        )
      end
    end
  end
end
