require 'rails_helper'

describe Untrack do
  let (:repository) { create(:repository) }
  let!(:hook) { create(:hook, resource: repository, active: true) }
  let(:pull_request) { create(:pull_request, repository_id: repository.id) }
  let(:pull_request_relation) { create(pull_request_relation, pull_request_id: pull_request.id) }

  describe "#destroy_entities" do
    def build
      described_class.new(repo: repository)
    end

    it 'call methods' do
      expect_any_instance_of(described_class).to receive(:destroy_hook)
      expect_any_instance_of(described_class).to receive(:destroy_pull_requests)
      build.perform
    end

    it 'deletes hook' do
      build.perform
      expect(repository.hooks.where(id: hook.id)).to be_empty
    end

    it 'deletes pull requests' do
      build.perform
      expect(repository.pull_requests).to be_empty
    end

    it 'deletes pr relations' do
      build.perform
      expect(pull_request.pull_request_relations).to be_empty
    end
  end
end
