require 'rails_helper'

RSpec.describe FroggoTeamMembership, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:github_user) }
    it { is_expected.to belong_to(:froggo_team) }
  end
end
