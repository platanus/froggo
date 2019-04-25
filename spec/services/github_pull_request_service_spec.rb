require 'rails_helper'

describe GithubPullRequestService do
  let(:token) { "blubli" }

  let(:service) { build(token: token) }

  let(:users) do
    Array.new(3) do
      create(:github_user)
    end
  end

  let(:github_pr_response) do
    double(
      id: 3,
      title: "Test",
      number: 1,
      state: "open",
      html_url: "http://www.gihub.com/prueba",
      created_at: "2017-12-12 09:17:52",
      updated_at: "2017-12-12 09:17:52",
      closed_at: "2017-12-12 09:17:52",
      merged_at: nil,
      user: users[0]
    )
  end

  let(:github_pr_response_merged) do
    double(
      id: 4,
      title: "Test",
      number: 2,
      state: "open",
      html_url: "http://www.gihub.com/prueba",
      created_at: "2017-12-12 09:17:52",
      updated_at: "2017-12-12 09:17:52",
      closed_at: "2017-12-12 09:17:52",
      merged_at: "2017-12-12 09:17:52",
      user: users[0],
      requested_reviewers: [],
      head: double(
        repo: double(
          full_name: 'platanus/froggo'
        )
      )
    )
  end

  let(:github_single_pr) do
    double(
      user: users[0],
      merged_by: users[0]
    )
  end

  let(:client) { double(:client) }

  def build(*_args)
    described_class.new(*_args)
  end

  describe "#import_github_pull_request" do
    context "when repository is not tracked" do
      let(:repository) { create(:repository, tracked: false) }

      it "doesn't create any pull request" do
        expect { service.import_github_pull_request(repository, github_pr_response) }.to(
          change { repository.pull_requests.count }.by(0)
        )
      end
    end

    context "when repository is tracked" do
      let(:repository) { create(:repository, tracked: true) }
      context "when PR doesn`t exist" do
        it "creates new pull request" do
          expect { service.import_github_pull_request(repository, github_pr_response) }.to(
            change { repository.pull_requests.count }.by(1)
          )
        end

        it "creates PR with valid data" do
          service.import_github_pull_request(repository, github_pr_response)
          pull_request = PullRequest.last

          expect(pull_request).to have_attributes(
            gh_id: 3,
            gh_number: 1,
            pr_state: "open",
            title: "Test"
          )
        end
      end

      context "when PR exists" do
        let!(:pull_request) do
          create(:pull_request, gh_id: 3, title: "Old Title", repository: repository)
        end

        it "does not create new pull requests" do
          expect { build(token: token).import_github_pull_request(repository, github_pr_response) }
            .not_to(change { PullRequest.count })
        end

        it "updates existing pull request" do
          expect { build(token: token).import_github_pull_request(repository, github_pr_response) }
            .to(
              change { pull_request.reload.title }.from("Old Title").to(github_pr_response.title)
            )
        end
      end

      context "when PR has been merged" do
        before do
          allow(BuildOctokitClient).to receive(:for).with(token: token, per_page: 20)
                                                    .and_return(client)
          allow(client).to receive(:pull_request).with(
            repository.full_name,
            github_pr_response_merged.number
          ).and_return(github_single_pr)
        end

        it "creates new pull request" do
          expect { service.import_github_pull_request(repository, github_pr_response_merged) }.to(
            change { PullRequest.count }.by(1)
          )
        end

        it "assigns github user to pull request" do
          service.import_github_pull_request(repository, github_pr_response_merged)
          expect(PullRequest.last.merged_by).to(
            eq(GithubUser.find_by(gh_id: github_pr_response_merged.user.id))
          )
        end
      end
    end
  end

  describe "#import_page_from_repository" do
    let(:repository) { create(:repository, tracked: true) }

    before do
      allow(BuildOctokitClient).to receive(:for).with(token: token, per_page: 20)
                                                .and_return(client)

      allow(client).to receive(:pull_requests).with(repository.full_name, state: "all", page: 1)
                                              .and_return([github_pr_response])

      expect(service).to receive(:import_github_pull_request).with(repository, github_pr_response)
                                                             .and_return(nil)
    end

    it "calls import_github_pull_request" do
      service.import_page_from_repository(repository, 1)
    end

    it "should have enqueued ImportPullRequestReviewsJob" do
      ActiveJob::Base.queue_adapter = :test
      expect { service.import_page_from_repository(repository, 1) }
        .to have_enqueued_job(ImportPullRequestReviewsJob)
    end
  end

  describe "#import_all_from_repository with two total pages" do
    let(:repository) { create(:repository, tracked: true) }
    let(:last_client_response) do
      double(rels: { last: double(href: 'http://www.github-example.com?page=2') })
    end

    before do
      allow(BuildOctokitClient).to receive(:for).with(token: token, per_page: 20)
                                                .and_return(client)

      allow(client).to receive(:pull_requests)
        .with(repository.full_name, state: "all", page: nil)
        .and_return([github_pr_response])
      allow(client).to receive(:last_response).and_return(last_client_response)
    end

    it "should have enqueued ImportPullRequestJob twice" do
      ActiveJob::Base.queue_adapter = :test
      expect { service.import_all_from_repository(repository) }
        .to have_enqueued_job(ImportPullRequestsJob).at_least(:twice)
    end
  end

  describe "#handle_webhook_event" do
    let(:repository) { create(:repository, tracked: true) }

    context 'when event data has requested_reviewers field' do
      let(:event_request_data) do
        double(
          action: 'review_requested',
          pull_request: github_pr_response,
          repository: double(id: repository.gh_id),
          requested_reviewer: users[1]
        )
      end

      let!(:pull_request) do
        create(:pull_request, gh_id: 3, title: "Old Title", repository: repository)
      end

      it "calls import_github_pull_request" do
        expect(service).to receive(:import_github_pull_request).with(repository, github_pr_response)
                                                               .and_return(pull_request)
        service.handle_webhook_event(event_request_data)
      end

      it 'calls add_requested_reviewers_to_pull_request' do
        expect(service).to receive(:add_requested_reviewers_to_pull_request)
          .with(pull_request, github_pr_response, users[1])
          .and_return(nil)
        service.handle_webhook_event(event_request_data)
      end
    end

    context 'when event data has not requested_reviewers field' do
      let(:event_request_data) do
        double(
          action: 'opened',
          pull_request: github_pr_response,
          repository: double(id: repository.gh_id)
        )
      end

      before do
        allow(event_request_data).to receive(:key?).with(:requested_reviewers).and_return(false)
      end

      it "calls import_github_pull_request" do
        expect(service).to receive(:import_github_pull_request).with(repository, github_pr_response)
                                                               .and_return(nil)
        service.handle_webhook_event(event_request_data)
      end
    end
  end

  describe '#delete_prs' do
    context 'with no pull request to delete' do
      let!(:gh_ids) { [] }
      it "doesn't delete any pull request" do
        expect { service.delete_prs(gh_ids) }.to change { PullRequest.count }.by(0)
      end
    end

    context 'with only one pull request to delete' do
      let!(:gh_ids) { [10] }
      let!(:pull_request) { create(:pull_request, gh_id: gh_ids.first) }
      let(:pr_ids) { [pull_request.id] }
      it 'deletes pull request' do
        expect { service.delete_prs(pr_ids) }.to change { PullRequest.count }.by(-1)
      end
    end

    context 'with more than one pull request to delete' do
      let!(:gh_ids) { [10, 20, 30] }
      let!(:pull_request1) { create(:pull_request, gh_id: gh_ids.first) }
      let!(:pull_request2) { create(:pull_request, gh_id: gh_ids[1]) }
      let!(:pull_request3) { create(:pull_request, gh_id: gh_ids[2]) }
      let(:pr_ids) { [pull_request1.id, pull_request2.id, pull_request3.id] }
      it 'deletes all pull requests' do
        expect { service.delete_prs(pr_ids) }.to change { PullRequest.count }.by(-3)
      end
    end
  end

  describe '#add_requested_reviewers_to_pull_request' do
    let(:repository) { create(:repository, tracked: true) }
    let!(:pull_request) do
      create(:pull_request, gh_id: 3, title: "Old Title", repository: repository)
    end
    let(:requested_reviewer) { users[1] }

    it 'adds new requested reviewers' do
      service.add_requested_reviewers_to_pull_request(
        pull_request,
        github_pr_response,
        requested_reviewer
      )

      expect(pull_request.pull_request_review_requests.length).to eq(1)
    end

    it 'pull request review requested has valid data' do
      service.add_requested_reviewers_to_pull_request(
        pull_request,
        github_pr_response,
        requested_reviewer
      )

      expect(pull_request.pull_request_review_requests.first).to have_attributes(
        pull_request_id: pull_request.id,
        github_user_id: users[1].id
      )
    end

    it 'does not add existing requested reviewers' do
      service.add_requested_reviewers_to_pull_request(
        pull_request,
        github_pr_response,
        requested_reviewer
      )
      service.add_requested_reviewers_to_pull_request(
        pull_request,
        github_pr_response,
        requested_reviewer
      )

      expect(pull_request.pull_request_review_requests.length).to eq(1)
    end
  end
end
