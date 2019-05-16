require 'rails_helper'

describe GithubPullRequestReviewService do
  let(:token) { "blubli" }
  let(:pull_request) { create(:pull_request, repository: repository) }
  let(:organization) { create(:organization, default_team_id: 0) }

  let(:service) { build(token: token) }

  let(:users) do
    create_list(
      :github_user,
      7,
      login: 'milla',
      name: 'Milla Jovovich',
      email: 'milla@jovovich.cl',
      avatar_url: 'url_to_avatar',
      html_url: 'url_to_html'
    )
  end

  let(:github_review_response) do
    double(
      id: 123,
      user: double(
        id: users[0].gh_id,
        login: users[0].login,
        name: users[0].name,
        email: users[0].email,
        avatar_url: users[0].avatar_url,
        html_url: users[0].html_url
      )
    )
  end

  let(:github_review_response2) do
    double(
      id: 123,
      user: double(
        id: users[3].gh_id,
        login: users[3].login,
        name: users[3].name,
        email: users[3].email,
        avatar_url: users[3].avatar_url,
        html_url: users[3].html_url
      )
    )
  end

  let(:github_review_response3) do
    double(
      id: 123,
      user: double(
        id: users[5].gh_id,
        login: users[5].login,
        name: users[5].name,
        email: users[5].email,
        avatar_url: users[5].avatar_url,
        html_url: users[5].html_url
      )
    )
  end

  let(:github_review_response4) do
    double(
      id: 123,
      user: double(
        id: users[6].gh_id,
        login: users[6].login,
        name: users[6].name,
        email: users[6].email,
        avatar_url: users[6].avatar_url,
        html_url: users[6].html_url
      )
    )
  end

  def build(*_args)
    described_class.new(*_args)
  end

  describe "#import_github_pull_request_review" do
    context "when repository is not tracked" do
      let(:repository) { create(:repository, tracked: false, organization: organization) }
      let(:include_recommendation) { true }

      it "doesn't create any reviews" do
        expect do
          service.import_github_pull_request_review(pull_request,
            github_review_response,
            organization.default_team_id,
            include_recommendation)
        end.to(change { PullRequestReview.count }.by(0))
      end
    end

    context "when repository is tracked" do
      let(:repository) { create(:repository, tracked: true, organization: organization) }
      let(:include_recommendation) { true }

      context "and review doesn't exist" do
        before do
          allow(service).to receive(:team_review_request_recommendations)
            .and_return ({
              best: [users[0], users[1], users[2]],
              worst: [users[3], users[4], users[5]]
            })
          allow(pull_request).to receive(:pull_request_review_requests)
            .and_return([
                          create(
                            :pull_request_review_request,
                            pull_request_id: pull_request.id,
                            github_user_id: users[0].id
                          ),
                          create(
                            :pull_request_review_request,
                            pull_request_id: pull_request.id,
                            github_user_id: users[5].id
                          ),
                          create(
                            :pull_request_review_request,
                            pull_request_id: pull_request.id,
                            github_user_id: users[6].id
                          )
                        ])
        end

        it "creates new pull request review" do
          expect do
            service.import_github_pull_request_review(pull_request,
              github_review_response,
              organization.default_team_id,
              include_recommendation)
          end.to(change { PullRequestReview.count }.by(1))
        end

        it "creates a pull request review with valid data" do
          service.import_github_pull_request_review(pull_request,
            github_review_response,
            organization.default_team_id,
            include_recommendation)
          pull_request_review = PullRequestReview.last

          expect(pull_request_review).to have_attributes(
            gh_id: 123,
            github_user_id: users[0].id
          )
        end

        context "with recommendation is followed" do
          it "defines behaviour as obedient" do
            service.import_github_pull_request_review(pull_request,
              github_review_response,
              organization.default_team_id,
              include_recommendation)
            pull_request_review = PullRequestReview.last
            expect(pull_request_review).to have_attributes(
              recommendation_behaviour: "obedient"
            )
          end
        end

        context "with recommendation isn't followed" do
          it "defines behaviour as indifferent" do
            service.import_github_pull_request_review(pull_request,
              github_review_response4,
              organization.default_team_id,
              include_recommendation)
            pull_request_review = PullRequestReview.last

            expect(pull_request_review).to have_attributes(
              recommendation_behaviour: "indifferent"
            )
          end
        end

        context "with not recommended is disregarded" do
          it "defines behaviour as rebel" do
            service.import_github_pull_request_review(pull_request,
              github_review_response3,
              organization.default_team_id,
              include_recommendation)
            pull_request_review = PullRequestReview.last

            expect(pull_request_review).to have_attributes(
              recommendation_behaviour: "rebel"
            )
          end
        end

        context "with review wasn't requested" do
          it "defines behaviour as not_defined" do
            service.import_github_pull_request_review(pull_request,
              github_review_response2,
              organization.default_team_id,
              include_recommendation)
            pull_request_review = PullRequestReview.last

            expect(pull_request_review).to have_attributes(
              recommendation_behaviour: "not_defined"
            )
          end
        end
      end

      context "and review exists" do
        before do
          create(:pull_request_review, gh_id: 123, pull_request: pull_request)
        end

        it "does not create new pull request reviews" do
          expect do
            build(token: token).import_github_pull_request_review(pull_request,
              github_review_response,
              organization.default_team_id,
              include_recommendation)
          end.not_to(change { PullRequestReview.count })
        end
      end
    end
  end

  describe "#import_all_from_repository" do
    let(:repository) { create(:repository, tracked: true, organization: organization) }

    it "calls import_all_from_pull_request" do
      expect(ImportPullRequestReviewsJob).to receive(:perform_later)
        .with(pull_request, token)
        .and_return(nil)

      service.import_all_from_repository(repository)
    end
  end

  describe "#import_all_from_pull_request" do
    let(:client) { double(:client, pull_requests: true) }
    let(:repository) { create(:repository, tracked: true, organization: organization) }
    let(:include_recommendation) { false }

    before do
      allow(BuildOctokitClient).to receive(:for).with(token: token).and_return(client)

      allow(client).to receive(:pull_request_reviews)
        .with(repository.full_name, 1, accept: 'application/vnd.github.thor-preview+json')
        .and_return([github_review_response])
    end

    it "calls import_github_pull_request_review" do
      expect(service).to receive(:import_github_pull_request_review)
        .with(pull_request,
          github_review_response,
          organization.default_team_id,
          include_recommendation)
        .and_return(nil)

      service.import_all_from_pull_request(pull_request)
    end
  end

  describe "#handle_webhook_event" do
    let(:repository) { create(:repository, tracked: true, organization: organization) }
    let!(:event_request_data) do
      double(
        action: 'submitted',
        review: github_review_response,
        pull_request: double(id: pull_request.gh_id),
        repository: double(id: repository.gh_id)
      )
    end
    let(:include_recommendation) { true }

    it "calls import_github_pull_request_review" do
      expect(service).to receive(:import_github_pull_request_review)
        .with(pull_request,
          github_review_response,
          organization.id,
          include_recommendation)
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
