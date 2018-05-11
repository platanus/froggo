require 'rails_helper'

describe GithubPullRequestService do
  let(:token) { "blubli" }

  let(:service) { build(token: token) }

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
      user: double(
        id: 1,
        login: "milla",
        name: "Milla Jovovich",
        email: "milla@jovovich.cl",
        avatar_url: "https://avatars2.githubusercontent.com/u/741483?v=4",
        html_url: "https://github.com/bunzli"
      )
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
      user: double(
        id: 1,
        login: "milla",
        name: "Milla Jovovich",
        email: "milla@jovovich.cl",
        avatar_url: "https://avatars2.githubusercontent.com/u/741483?v=4",
        html_url: "https://github.com/bunzli"
      ),
      head: double(
        repo: double(
          full_name: 'platanus/froggo'
        )
      )
    )
  end

  let(:github_single_pr) do
    double(
      user: double(
        id: 1,
        login: "milla",
        name: "Milla Jovovich",
        email: "milla@jovovich.cl",
        avatar_url: "https://avatars2.githubusercontent.com/u/741483?v=4",
        html_url: "https://github.com/bunzli"
      ),
      merged_by: double(
        id: 1,
        login: "milla",
        name: "Milla Jovovich",
        email: "milla@jovovich.cl",
        avatar_url: "https://avatars2.githubusercontent.com/u/741483?v=4",
        html_url: "https://github.com/bunzli"
      )
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
            github_pr_response_merged.head.repo.full_name,
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
    let(:event_request_data) do
      double(
        action: 'opened',
        pull_request: github_pr_response,
        repository: double(id: repository.gh_id)
      )
    end

    it "calls import_github_pull_request" do
      expect(service).to receive(:import_github_pull_request).with(repository, github_pr_response)
                                                             .and_return(nil)
      service.handle_webhook_event(event_request_data)
    end
  end
end
