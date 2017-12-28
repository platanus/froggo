require 'spec_helper'

RSpec.describe GithubUser, type: :model do
  describe 'validations' do
    it { should validate_presence_of :gh_id }
    it { should validate_presence_of :login }
  end

  describe 'relationships' do
    it { should have_many(:pull_requests) }
    it { should have_many(:pull_request_relations) }
  end
end
