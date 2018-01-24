require 'rails_helper'

describe GithubRepositoryService do
  def build(*_args)
    described_class.new(*_args)
  end

  let (:client) { double(:client) }
  let (:token) { 'a token' }
  let (:repository) { create(:repository) }

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
end