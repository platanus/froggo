require 'rails_helper'

RSpec.describe FroggoTeam, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:froggo_team_memberships) }
    it { is_expected.to have_many(:github_users) }
  end
end
