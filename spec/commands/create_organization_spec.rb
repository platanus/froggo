require 'rails_helper'

describe CreateOrganization do
  let(:token) { "token" }
  let(:github_organization) { { id: 123, login: "Platanus" } }
  let(:organization) { Organization.find_by(gh_id: 123) }

  let(:github_organization_webhook_service) { double("github_organization_webhook_service") }

  def perform
    described_class.for(token: token, github_organization: github_organization)
  end

  context "when organization does not exist" do
    before do
      expect(OrganizationSyncJob).to receive(:perform_later)
        .with(instance_of(OrganizationSync), token)

      expect(Github::OrganizationWebhookService).to receive(:new)
        .with(token: token, organization: instance_of(Organization))
        .and_return(github_organization_webhook_service)

      expect(github_organization_webhook_service).to receive(:set)
    end

    it { expect { perform }.to change { Organization.count }.by(1) }
    it { expect { perform }.to change { OrganizationSync.count }.by(1) }

    it "creates the correct Organization and OrganizationSync" do
      perform

      expect(Organization.last).to have_attributes(gh_id: 123, login: "Platanus")
      expect(OrganizationSync.last.organization.id).to eq(organization.id)
    end
  end

  context "when organization exists" do
    before do
      create(:organization, gh_id: 123, login: "Platanus")
    end

    it { expect { perform }.to change { Organization.count }.by(0) }
    it { expect { perform }.to change { OrganizationSync.count }.by(0) }
  end
end
