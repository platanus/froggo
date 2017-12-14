require 'rails_helper'

describe RepositoryObserver do
  let(:repository) { create(:repository) }

  def trigger(type, event, object = repository)
    described_class.trigger(type, event, object)
  end

  describe "#update_hook" do
    it "Calls service when tracked" do
      expect_any_instance_of(HookService).to(
        receive(:subscribe).with(repository).and_return(true)
      )
      repository.tracked = true

      trigger(:after, :save)
    end
  end
end
