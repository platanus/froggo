require 'rails_helper'

RSpec.describe PullRequestRelation, type: :model do
  describe 'validations' do
    it { should validate_presence_of :relation_type }
  end

  describe 'relationships' do
    it { should belong_to(:pull_request) }
    it { should belong_to(:github_user) }
  end
end
