require 'rails_helper'

RSpec.describe PullRequest, type: :model do
  describe 'validations' do
    it { should validate_presence_of :gh_id }
    it { should validate_presence_of :pr_state }
  end

  describe 'relationships' do
    it { should belong_to(:repository) }
  end
end
