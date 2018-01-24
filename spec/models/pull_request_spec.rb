require 'rails_helper'

RSpec.describe PullRequest, type: :model do
  describe 'validations' do
    it { should validate_presence_of :gh_id }
    it { should validate_presence_of :pr_state }
  end

  describe 'relationships' do
    it { should belong_to(:repository) }
    it { should belong_to(:owner) }
    it { should belong_to(:merged_by) }
  end

  describe 'on save' do
    let!(:repo) { create(:repository) }
    it 'touches repository' do
      expect do
        create(:pull_request, repository: repo)
        repo.reload
      end.to(change { repo.last_pull_request_modification })
    end
  end
end
