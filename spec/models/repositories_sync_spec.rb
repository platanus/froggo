require 'rails_helper'

RSpec.describe RepositoriesSync, type: :model do
  describe 'relationships' do
    it { should belong_to(:organization) }
  end
end
