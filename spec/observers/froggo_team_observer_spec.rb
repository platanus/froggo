require 'rails_helper'

describe FroggoTeamObserver, observers: true do
  describe "#update_default_team_id" do
    let(:organization) { create(:organization, default_team_id: 10) }
    let!(:froggo_team) { create(:froggo_team, id: 10, organization: organization) }

    before do
      froggo_team.destroy
    end

    it "if froggo team is the organization's default team sets default_team_id to nil" do
      expect(Organization.find(organization.id).default_team_id).to be(nil)
    end
  end
end
