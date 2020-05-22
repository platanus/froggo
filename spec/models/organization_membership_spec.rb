require 'rails_helper'

RSpec.describe OrganizationMembership, type: :model do
  describe 'relationships' do
    it { should belong_to(:organization) }
    it { should belong_to(:github_user) }
  end
end
