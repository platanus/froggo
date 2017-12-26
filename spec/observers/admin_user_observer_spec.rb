require 'rails_helper'

describe AdminUserObserver do
  let(:object) { build(:admin_user) }

  def trigger(type, event)
    described_class.trigger(type, event, object)
  end

  describe "#after_save" do
    context "when token changed" do
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

    context "when token didn`t changed" do
      it "does not create organizations" do
        expect_any_instance_of(GithubService).not_to receive(:create_organizations)

        trigger(:after, :save)
      end
    end
  end
end
