require 'rails_helper'

RSpec.describe PullRequest, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :gh_id }
    it { is_expected.to validate_presence_of :pr_state }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:repository) }
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to belong_to(:merged_by).optional(true) }
    it { is_expected.to have_many(:pull_request_review_requests) }
  end
end
