require 'rails_helper'

describe GithubOrgMembershipService do
  def build(*_args)
    described_class.new(*_args)
  end

  let(:token) { 'blubli' }
  let(:service) { build(token: token) }
  let(:client) { double }
  let(:organization) { create(:organization) }
  let(:github_response) do
    [
      double(
        login: 'TestUser',
        id: 10,
        avatar_url: 'user avatar',
        html_url: 'user html url',
        email: '',
        name: ''
      )
    ]
  end

  before do
    expect(BuildOctokitClient).to receive(:for).and_return(client)
  end

  describe "#import_all_from_organization" do
    before do
      expect(client).to receive(:org_members).with(organization.login).and_return(github_response)
    end
    context "when membership doen't exist" do
      it "creates new organization membership" do
        expect do
          service.import_all_from_organization(organization)
          organization.reload
        end.to change { organization.organization_memberships.count }.by(1)
        expect(organization.members.last.login).to eq(github_response.first.login)
      end
    end

    context "when membership exists" do
      before do
        expect(client).to receive(:org_members).with(organization.login).and_return(github_response)
                                               .at_most(2).times
        service.import_all_from_organization(organization)
      end

      it "doesn't create new organization membership" do
        expect do
          service.import_all_from_organization(organization)
          organization.reload
        end.to change { organization.organization_memberships.count }.by(0)
      end
    end
  end
end
