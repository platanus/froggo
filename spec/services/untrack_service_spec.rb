require 'rails_helper'

describe UntrackService do
  let (:repository) { create(:repository) }
  let!(:hook) { create(:hook, repository_id: repository.id, active: true) }
  let(:pull_request) { create(:pull_request, repository_id: repository.id) }
  let(:pull_request_relation) { create(pull_request_relation, pull_request_id: pull_request.id) }

  describe "#destroy_entities" do
    def build
      described_class.new(repo: repository)
    end

    it 'call methods' do
      expect_any_instance_of(described_class).to receive(:destroy_hook)
      expect_any_instance_of(described_class).to receive(:destroy_pull_request)
      build.destroy_entities
    end

    it 'deletes hook' do
      build.destroy_entities
      expect(Hook.where(repository_id: repository.id)).to be_empty
    end

    it 'deletes pull requests' do
      build.destroy_entities
      expect(PullRequest.where(repository_id: repository.id)).to be_empty
    end

    it 'deletes pr relations' do
      build.destroy_entities
      expect(PullRequestRelation.where(pull_request_id: pull_request.id)).to be_empty
    end
  end
end
