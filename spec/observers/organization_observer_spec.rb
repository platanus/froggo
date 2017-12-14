require 'rails_helper'

describe OrganizationObserver do
  let(:admin_user) { build(:admin_user, token: "thisittoken") }
  let(:object) { build(:organization, owner_id: admin_user.id) }

  def trigger(type, event)
    described_class.trigger(type, event, object)
  end

  describe "#after_save" do
    before do
      allow(OctokitClient).to(
        receive(:client)
      ).and_return(double)
      allow(OctokitClient).to(
        receive(:fetch_organization_repositories)
      ).and_return([])
    end

    it "calls GithubService when tracked" do
      object.tracked = true

      expect { trigger(:after, :save) }.to change(GithubWorker.jobs, :size)
    end

    it "doesn't call GithubService when not tracked" do
      object.tracked = false

      expect { trigger(:after, :save) }.not_to change(GithubWorker.jobs, :size)
    end
  end
end
