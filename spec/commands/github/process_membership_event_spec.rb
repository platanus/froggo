require 'rails_helper'

describe Github::ProcessMembershipEvent do
  def perform
    described_class.for(event_payload: event_payload)
  end

  let!(:user) { create(:github_user, gh_id: 1) }
  let!(:organization) { create(:organization, gh_id: 234, default_team_id: 123) }
  let(:event_payload) do
    double(
      action: action,
      member: double(id: 1),
      team: double(id: 123),
      organization: double(id: 234)
    )
  end

  context 'when user is added to default team in Github' do
    let!(:organization_membership) do
      create(
        :organization_membership,
        github_user: user,
        organization: organization,
        is_member_of_default_team: false
      )
    end
    let(:action) { 'added' }

    it 'user is added to default team in local DB' do
      perform
      expect(OrganizationMembership.last.is_member_of_default_team).to be(true)
    end
  end

  context 'when user is removed from default team in Github' do
    let!(:organization_membership) do
      create(
        :organization_membership,
        github_user: user,
        organization: organization,
        is_member_of_default_team: true
      )
    end
    let(:action) { 'removed' }

    it 'user is removed from default team in local DB' do
      perform
      expect(OrganizationMembership.last.is_member_of_default_team).to be(false)
    end
  end
end
