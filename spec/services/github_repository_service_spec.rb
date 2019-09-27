require 'rails_helper'

describe GithubRepositoryService do
  def build(*_args)
    described_class.new(*_args)
  end

  let (:client) { double(:client) }
  let (:token) { 'a token' }
  let (:repository) { create(:repository) }
  let (:organization) { create(:organization) }

  let (:github_on_created_hook_response) do
    {
      type: "Repository",
      id: 20649728,
      name: "web",
      active: true,
      events: ["pull_request", "pull_request_review"],
      config:
      {
        url: "https://pl-froggo-staging.herokuapp.com/github_events",
        content_type: "json",
        insecure_ssl: "0"
      },
      updated_at: "2018-01-24 17:52:24 UTC",
      created_at: "2018-01-24 17:52:24 UTC",
      url: "https://api.github.com/repos/ACM-Planner/dataset/hooks/20649728",
      test_url: "https://api.github.com/repos/repo/hooks/20649728/test",
      ping_url: "https://api.github.com/repos/ACM-Planner/dataset/hooks/20649728/pings",
      last_response:
      {
        code: nil,
        status: "unused",
        message: nil
      }
    }
  end

  let (:github_on_hooks_response) do
    [
      {
        type: "Repository",
        id: 26863215,
        name: "web",
        active: true,
        events: ["pull_request", "pull_request_review"],
        config: {
          content_type: "json",
          secret: "********",
          url: "#{ENV['APPLICATION_HOST']}/github_events",
          insecure_ssl: "0"
        }
      },
      {
        config: {
          content_type: "json",
          secret: "********",
          url: "https://pl-froggo-fake.herokuapp.com/github_events",
          insecure_ssl: "0"
        }
      }
    ]
  end

  def mock_github_response(response)
    allow(client).to receive(:create_hook)
      .with(repository.full_name,
        'web',
        {
          url: "#{ENV['APPLICATION_HOST']}/github_events",
          content_type: 'json',
          secret: ENV['GH_HOOK_SECRET']
        },
        events: ['pull_request', 'pull_request_review'],
        active: true)
      .and_return(response)
  end

  def mock_github_response_iteration(first_response, second_response)
    allow(client).to receive(:create_hook)
      .with(repository.full_name,
        'web',
        {
          url: "#{ENV['APPLICATION_HOST']}/github_events",
          content_type: 'json',
          secret: ENV['GH_HOOK_SECRET']
        },
        events: ['pull_request', 'pull_request_review'],
        active: true)
      .and_return(first_response, second_response)
  end

  before do
    allow(BuildOctokitClient).to receive(:for).with(token: token).and_return(client)
  end

  describe '#set_webhook' do
    context 'when repository exists in github' do
      before do
        mock_github_response(github_on_created_hook_response)
      end

      it 'creates a hook' do
        expect { build(token: token).set_webhook(repository) }
          .to change { Hook.all.count }.by(1)
      end
    end

    context 'when repository does not exist in github' do
      before do
        mock_github_response(Octokit::NotFound)
      end

      it 'throws github error' do
        response = build(token: token).set_webhook(repository)
        expect(response).to eq(nil)
      end
    end

    context 'when a hook exists in github repository' do
      before do
        mock_github_response_iteration(Octokit::UnprocessableEntity,
          github_on_created_hook_response)
        allow(client).to receive(:hooks)
          .with(repository.full_name)
          .and_return(github_on_hooks_response)
        allow(client).to receive(:remove_hook)
          .with(repository.full_name, 26863215)
          .and_return(true)
      end

      it 'removes and create a new hook' do
        expect { build(token: token).set_webhook(repository) }
          .to change { Hook.all.count }.by(1)
      end
    end
  end

  describe '#remove_webhook' do
    context 'with existing repository and hook' do
      before do
        hook = create(:hook, resource: repository)

        allow(client).to receive(:remove_hook)
          .with(repository.full_name, hook.gh_id)
          .and_return(true)
      end

      it 'removes de hook from bd' do
        expect { build(token: token).remove_webhook(repository) }
          .to change { Hook.all.count }.by(-1)
      end

      it 'removes the hook from github' do
        response = build(token: token).remove_webhook(repository)
        expect(response).to eq(true)
      end
    end

    context 'with existing invalid repository' do
      it 'does not remove hook from bd' do
        expect { build(token: token).remove_webhook(repository) }
          .to change { Hook.all.count }.by(0)
      end

      it 'fails to remove from github' do
        response = build(token: token).remove_webhook(repository)
        expect(response).to eq(nil)
      end
    end
  end

  describe "#import_all_from_organization" do
    let(:github_repositories) do
      [
        {
          id: 101,
          full_name: "Tesla labs"
        }
      ]
    end
    let(:service) { build(token: token) }

    before do
      allow(client).to receive(:org_repos).with(organization.login).and_return(github_repositories)
    end

    def run_method
      service.import_all_from_organization(organization)
      organization.repositories.reload
    end

    context "when repository does not exist" do
      it { expect { run_method }.to change { organization.repositories.count }.by(1) }
      it { expect(run_method.first.reload.full_name).to eq("Tesla labs") }
    end

    context "when repository exists" do
      before do
        create(:repository, organization: organization, gh_id: 101, full_name: "Platanus labs")
      end

      it { expect { run_method }.to change { organization.repositories.count }.by(0) }
      it { expect(run_method.first.full_name).to eq("Tesla labs") }
    end

    context "when exists old repositories in db" do
      let!(:org_repo) { create(:repository, organization: organization, gh_id: 101, full_name: "Platanus labs") }
      let!(:not_org_repo) { create(:repository, organization: organization, gh_id: 105, full_name: "I don't exist") }

      before do
        allow(service).to receive(:remove_webhook)
      end

      it { expect { run_method }.to change { organization.repositories.count }.by(-1) }
      it do
        run_method
        expect(service).to have_received(:remove_webhook).with(not_org_repo).once
      end
      it do
        run_method
        expect(service).not_to have_received(:remove_webhook).with(org_repo)
      end
    end
  end
end
