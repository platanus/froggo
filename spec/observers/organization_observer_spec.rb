require 'rails_helper'

describe OrganizationObserver do
  describe "#after_save" do
    let(:admin_user) { build(:admin_user, token: "thisittoken") }
    let(:client) { double }

    def trigger(type, event, object)
      described_class.trigger(type, event, object)
    end

    describe 'GithubWorker calls' do
      let(:object) { build(:organization, owner_id: admin_user.id, tracked: false) }
      before do
        allow_any_instance_of(GithubService).to(
          receive(:client)
        ).and_return(client)
        allow_any_instance_of(GithubService).to(
          receive(:create_organization_repositories)
        ).and_return(nil)

        allow_any_instance_of(HookService).to receive(:subscribe)
        allow_any_instance_of(HookService).to receive(:unsubscribe)
      end

      it "calls GithubService when tracked" do
        object.tracked = true

        expect { trigger(:after, :save, object) }.to change(GithubWorker.jobs, :size)
      end

      it "doesn't call GithubService when not tracked" do
        object.tracked = false

        expect { trigger(:after, :save, object) }.not_to change(GithubWorker.jobs, :size)
      end
    end

    describe 'HookService calls' do
      let(:object) { build(:organization, owner_id: admin_user.id, tracked: false) }

      it "calls subscribe when tracked" do
        expect_any_instance_of(HookService).to receive(:subscribe)
          .with(object)

        object.tracked = true
        trigger(:after, :save, object)
      end

      it "calls unsubscribe when not tracked" do
        expect_any_instance_of(HookService).to receive(:unsubscribe)
          .with(object)

        object.tracked = false
        trigger(:after, :save, object)
      end
    end
  end
end
