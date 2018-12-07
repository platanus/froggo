require 'rails_helper'

describe GithubOrgMembershipService do
  def build(*_args)
    described_class.new(*_args)
  end

  let(:token) { 'blubli' }
  let(:service) { build(token: token) }
  let(:client) { double }
  let(:organization) { create(:organization) }
  let(:user) do
    double(
      login: 'TestUser',
      id: 10,
      avatar_url: 'user avatar',
      html_url: 'user html url',
      email: '',
      name: ''
    )
  end
  let(:user2) do
    double(
      login: 'TestUser2',
      id: 20,
      avatar_url: 'user avatar',
      html_url: 'user html url',
      email: '',
      name: ''
    )
  end
  let(:github_response) { [user] }
  let(:github_response_2) { [user, user2] }

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

  describe '#ex_members_ids' do
    context "when membership doesn't exist" do
      before do
        allow(client).to receive(:org_members).with(organization.login)
                                              .and_return(github_response_2, github_response)
        service.import_all_from_organization(organization)
      end

      it 'returns an array with ex_member id' do
        expect(organization.members.where(id: service.ex_members_ids(organization)).first.gh_id)
          .to eq(20)
      end
    end

    context 'when membership exists' do
      before do
        allow(client).to receive(:org_members).with(organization.login).and_return(github_response)
        service.import_all_from_organization(organization)
      end

      it 'returns an empty array' do
        expect(service.ex_members_ids(organization)).to be_empty
      end
    end
  end

  describe '#delete_ex_members' do
    context "when membership doesn't exist" do
      before do
        allow(client).to receive(:org_members).with(organization.login)
                                              .and_return(github_response_2, github_response)
        service.import_all_from_organization(organization)
      end

      let(:ids) { organization.members.where(gh_id: 10) }
      it 'deletes user' do
        expect do
          service.delete_ex_members(organization, ids)
          organization.reload
        end.to change { organization.organization_memberships.count }.by(-1)
      end
    end

    context 'when membership exists' do
      let(:ids) { [] }
      before do
        allow(client).to receive(:org_members).with(organization.login).and_return(github_response)
        service.import_all_from_organization(organization)
      end

      it "doesn't delete user" do
        expect do
          service.delete_ex_members(organization, ids)
          organization.reload
        end.to change { organization.organization_memberships.count }.by(0)
      end
    end
  end
end
