require 'rails_helper'

describe RepositoryObserver do
  let(:organization) { create(:organization) }
  let!(:repository) { create(:repository, organization_id: organization.id) }

  def trigger(type, event, object = repository)
    described_class.trigger(type, event, object)
  end

  describe '#update_hook' do
    let!(:admin) { build(:admin_user) }

    it 'calls service when tracked' do
      expect_any_instance_of(HookService).to(
        receive(:subscribe).with(repository).and_return(true)
      )
      repository.tracked = true

      trigger(:after, :save)
    end

    context 'calls github worker' do
      before do
        allow_any_instance_of(HookService).to(
          receive(:subscribe).with(repository).and_return(true)
        )
      end

      it 'adds new worker when tracked' do
        repository.tracked = true

        expect { trigger(:after, :save) }.to change(GithubWorker.jobs, :size)
      end

      it "doesn't add new worker when isn't tracked" do
        repository.tracked = false

        expect { trigger(:after, :save) }.not_to change(GithubWorker.jobs, :size)
      end
    end
  end
end
