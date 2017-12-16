require 'rails_helper'

describe HookService do
  let! (:admin_user) { build(:admin_user, token: 'a token') }
  let (:repository) { create(:repository) }
  let (:client) { double }
  let (:hook) { create(:hook, repository: repository, active: false) }
  let (:gh_conf) do
    {
      url: "#{ENV['APPLICATION_HOST']}/github_events",
      content_type: 'json',
      secret: ENV['GH_HOOK_SECRET']
    }
  end
  let (:gh_response) do
    {
      type: "",
      id: 1,
      name: "",
      active: true,
      ping_url: "",
      test_url: ""
    }
  end

  subject { described_class.new }

  before do
    allow(OctokitClient).to receive(:client).and_return(client)
  end

  describe "#subscribe" do
    def subscribe
      subject.subscribe(repository)
    end

    context "when the hook exist for this repository" do
      before do
        expect(client).to receive(:edit_hook).with(
          repository.full_name, hook.gh_id, 'web', gh_conf, active: true
        )
      end

      it { expect { subscribe }.to change { hook.reload.active }.from(false).to true }
    end

    context "when the hook doesn't exist for this repository" do
      before do
        expect(client).to receive(:create_hook).with(
          repository.full_name, 'web', gh_conf, events: ['push', 'pull_request'], active: true
        ).and_return(gh_response)
        HookService.new.subscribe(repository)
        @hook = Hook.last
      end

      it { expect(@hook.active).to eq(true) }
      it { expect(@hook.repository).to eq(repository) }
    end
  end

  describe "#unsubscribe" do
    let (:hook) { create(:hook, repository: repository, active: true) }

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
