require 'rails_helper'

describe HookObserver do
  let(:organization) { create(:organization) }
  let(:repository) { create(:repository, organization_id: organization.id) }
  let(:hook) { create(:hook, repository_id: repository.id) }

  def trigger(type, event, object = hook)
    described_class.trigger(type, event, object)
  end

  describe "#before_destroy" do
    it 'calls hook service' do
      expect_any_instance_of(HookService).to(
        receive(:destroy_api_hook).with(hook).and_return(true)
      )
      trigger(:before, :destroy)
    end
  end
end
