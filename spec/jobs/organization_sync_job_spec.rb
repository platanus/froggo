require 'rails_helper'

RSpec.describe OrganizationSyncJob, type: :job do
  describe '#perform' do
    let(:organization) { double }
    let(:org_sync) { double(organization: organization, execute!: nil, complete!: nil) }
    let(:token) { 'token' }
    let(:gh_ids) { double }
    let(:prs_ids) { double }
    let(:perform_now) { OrganizationSyncJob.perform_now(org_sync, token) }
    let(:repository_service) { double(import_all_from_organization: nil) }
    let(:org_cleaner_service) { double(clean: nil) }
    let(:membership_service) do
      double(import_all_from_organization: nil,
             ex_members_ids: gh_ids,
             delete_ex_members: nil)
    end

    before do
      allow(GithubRepositoryService).to receive(:new).and_return(repository_service)
      allow(GithubOrgMembershipService).to receive(:new).and_return(membership_service)
      allow(OrganizationCleanerService).to receive(:new).and_return(org_cleaner_service)
    end

    it 'calls GithubOrgMembershipService#import_all_from_organization' do
      expect(membership_service).to receive(:import_all_from_organization)
        .with(org_sync.organization).and_return(nil)
      perform_now
    end

    it 'calls GithubRepositoryService#import_all_from_organization' do
      expect(repository_service).to receive(:import_all_from_organization)
        .with(org_sync.organization).and_return(nil)
      perform_now
    end
  end
end
