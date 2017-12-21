require 'rails_helper'

describe HookService do
  let! (:admin_user) { build(:admin_user, token: 'a token') }
  let (:organization) { create(:organization, owner: admin_user) }
  let (:repository) { create(:repository, organization: organization) }
  let (:client) { double }
  let (:gh_conf) do
    {
      url: "#{ENV['APPLICATION_HOST']}/github_events",
      content_type: 'json',
      secret: ENV['GH_HOOK_SECRET']
    }
  end

  subject { described_class.new }

  before do
    allow(OctokitClient).to receive(:client).and_return(client)
  end

  describe 'org_hooks' do
    let (:gh_response) do
      {
        type: 'Organization',
        id: 1,
        name: 'web',
        active: true,
        ping_url: 'https://api.github.com/orgs/octocat/hooks/1/pings',
        test_url: 'https://api.github.com/orgs/octocat/hooks/1/tests'
      }
    end

    describe "#subscribe" do
      let (:hook) { create(:hook, resource: organization, active: false) }

      def subscribe
        subject.subscribe(organization)
      end

      context "when the hook exist for this organization" do
        it "edits hook" do
          expect(client).to receive(:edit_org_hook).with(
            organization.login, hook.gh_id, gh_conf, active: true
          )

          expect { subscribe }.to change { hook.reload.active }.from(false).to true
        end
      end

      context "when the hook doesn't exist for this organization" do
        before do
          expect(client).to receive(:create_org_hook).with(
            organization.login, gh_conf,
            events: ['repository'], active: true
          ).and_return(gh_response)
          HookService.new.subscribe(organization)
          @hook = Hook.last
        end

        it { expect(@hook.active).to eq(true) }
        it { expect(@hook.resource).to eq(organization) }
      end
    end

    describe "#unsubscribe" do
      let (:hook) { create(:hook, resource: organization, active: true) }

      def unsubscribe
        subject.unsubscribe(organization)
      end

      before do
        expect(client).to receive(:edit_org_hook).with(
          organization.login, hook.gh_id, gh_conf, active: false
        )
      end

      it { expect { unsubscribe }.to change { hook.reload.active }.from(true).to false }
    end
  end

  describe 'repo_hooks' do
    let (:gh_response) do
      {
        type: 'Repository',
        id: 1,
        name: 'web',
        active: true,
        ping_url: 'https://api.github.com/repos/octocat/Hello-World/hooks/1/pings',
        test_url: 'https://api.github.com/repos/octocat/Hello-World/hooks/1/tests'
      }
    end

    describe "#subscribe" do
      let (:hook) { create(:hook, resource: repository, active: false) }

      def subscribe
        subject.subscribe(repository)
      end

      context "when the hook exist for this repository" do
        it "edits hook" do
          expect(client).to receive(:edit_hook).with(
            repository.full_name, hook.gh_id, 'web', gh_conf, active: true
          )

          expect { subscribe }.to change { hook.reload.active }.from(false).to true
        end
      end

      context "when the hook doesn't exist for this repository" do
        before do
          expect(client).to receive(:create_hook).with(
            repository.full_name, 'web', gh_conf,
            events: ['pull_request', 'pull_request_review'], active: true
          ).and_return(gh_response)
          HookService.new.subscribe(repository)
          @hook = Hook.last
        end

        it { expect(@hook.active).to eq(true) }
        it { expect(@hook.resource).to eq(repository) }
      end
    end

    describe "#unsubscribe" do
      let (:hook) { create(:hook, resource: repository, active: true) }

      def unsubscribe
        subject.unsubscribe(repository)
      end

      before do
        expect(client).to receive(:edit_hook).with(
          repository.full_name, hook.gh_id, 'web', gh_conf, active: false
        )
      end

      it { expect { unsubscribe }.to change { hook.reload.active }.from(true).to false }
    end
  end

  describe "#destroy_api_hook" do
    let (:hook) { create(:hook, repository: repository, active: true) }

    def destroy
      subject.destroy_api_hook(hook)
    end

    context "when the hook is not tracked" do
      before do
        expect(client).to receive(:remove_hook).with(
          repository.full_name, hook.gh_id
        )
      end
    end
  end
end
