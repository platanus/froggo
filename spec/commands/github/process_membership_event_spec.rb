require 'rails_helper'

describe Github::ProcessMembershipEvent do
  def perform
    described_class.for(event_payload: event_payload)
  end

  let(:organization_gh_id) { 234 }
  let(:team_id) { 123 }
  let!(:organization) { create(:organization, gh_id: organization_gh_id, default_team_id: team_id) }
  let(:member_payload) do
    {
      login: "Codertocat",
      id: user_gh_id,
      avatar_url: "",
      html_url: ""
    }
  end
  let(:event_payload) do
    RecursiveOpenStruct.new(
      action: action,
      member: member_payload,
      team: { id: team_id },
      organization: { id: organization_gh_id }
    )
  end

  context 'when user does not exist in Froggo' do
    let(:action) { 'added' }
    let(:user_gh_id) { 345 }

    it "doesn't add a new Organization Membership for him" do
      expect { perform }.not_to(change { OrganizationMembership.count })
    end
  end

  context 'when user already exists in Froggo' do
    let(:user_gh_id) { 1234 }
    let!(:user) { create(:github_user, gh_id: user_gh_id) }

    context 'when user is added to new organization' do
      let(:action) { 'added' }
      let(:organization_gh_id) { 456 }

      it 'creates new Organization Membership' do
        expect { perform }.to change { OrganizationMembership.count }.by(1)
      end
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
        expect { perform }.to change { organization_membership.reload.is_member_of_default_team }
          .from(false).to(true)
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
        expect { perform }.to change { organization_membership.reload.is_member_of_default_team }
          .from(true).to(false)
      end
    end
  end
end
