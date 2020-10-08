require 'rails_helper'

RSpec.describe FroggoTeamMembership, type: :model do
  subject(:membership) { described_class.new }

  let!(:user) { create(:github_user) }
  let!(:organization) { create(:organization) }
  let!(:team) { create(:froggo_team, organization: organization) }

  describe "validations" do
    it do
      expect(membership).to validate_numericality_of(:assignment_percentage)
        .only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(100)
    end
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:github_user) }
    it { is_expected.to belong_to(:froggo_team) }
  end

  describe 'update callback' do
    let(:current_date) { Time.zone.local(1996, 12, 17) }

    before do
      Timecop.freeze(current_date)
    end

    context "when member is deactivated" do
      let(:membership) do
        create(
          :froggo_team_membership,
          github_user: user,
          froggo_team: team
        )
      end

      def deactivate_membership
        membership.update(is_member_active: false)
      end

      it "membership last_deactivation_date is updated" do
        expect { deactivate_membership }.to change { membership.last_deactivation_date }
          .to(current_date)
      end

      it "membership last_activation_date is not changed" do
        expect { deactivate_membership }.not_to (change { membership.last_activation_date })
      end
    end

    context "when member is activated" do
      let(:membership) do
        create(
          :froggo_team_membership,
          github_user: user,
          froggo_team: team,
          is_member_active: false
        )
      end

      def activate_membership
        membership.update(is_member_active: true)
      end

      it "membership last_activation_date is updated" do
        expect { activate_membership }.to change { membership.last_activation_date }
          .to(current_date)
      end

      it "membership last_deactivation_date is not changed" do
        expect { activate_membership }.not_to (change { membership.last_deactivation_date })
      end
    end
  end
end
