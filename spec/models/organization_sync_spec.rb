require 'rails_helper'

RSpec.describe OrganizationSync, type: :model do
  describe 'relationships' do
    it { should belong_to(:organization) }
  end
end
