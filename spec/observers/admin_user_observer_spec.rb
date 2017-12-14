require 'rails_helper'

describe AdminUserObserver do
  let(:object) { create(:admin_user) }

  def trigger(type, event)
    described_class.trigger(type, event, object)
  end

  describe "#after_save" do
    it "calls GithubService with successful oauth" do
      expect_any_instance_of(GithubService).to(
        receive(:create_organizations)
      )
      object.token = "thisistoken"
      trigger(:after, :save)
    end

    it "doesn't call GithubService with unsuccessful oauth" do
      expect_any_instance_of(GithubService).not_to(
        receive(:create_organizations)
      )
      object.token = nil
      trigger(:after, :save)
    end
  end
end
