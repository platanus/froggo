require 'rails_helper'

describe GithubPullRequestService do
  let(:token) { "blubli" }
  let(:repository) { create(:repository) }

  let(:service) { build(token: token) }

  let(:github_prs_response) do
    [
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
    ]
  end

  let(:client) { double(:client, pull_requests: true) }

  def build(*_args)
    described_class.new(*_args)
  end

  before do
    allow(BuildOctokitClient).to receive(:for).with(token: token).and_return(client)

    allow(client).to receive(:pull_requests).with(repository.full_name, state: "all")
                                            .and_return(github_prs_response)
  end

  describe "#import_all_from_repository" do
    context "when PR doesn`t exist" do
      it "creates new pull request" do
        expect { service.import_all_from_repository(repository) }.to(
          change { PullRequest.count }.by(1)
        )
      end

      it "creates PR with valid data" do
        service.import_all_from_repository(repository)
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
      before do
        create(:pull_request, gh_id: 3, repository: repository)
      end

      it "does not create new pull requests" do
        expect { build(token: token).import_all_from_repository(repository) }.not_to(
          change { PullRequest.count }
        )
      end
    end
  end
end
