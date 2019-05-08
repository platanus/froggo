require 'rails_helper'

describe Github::OrganizationWebhookService do
  let(:token) { "token" }
  let(:organization) { create(:organization, login: "Platanus") }

  let(:client) { double(:client, pull_requests: true) }
  let(:webook_config) { { url: "#{ENV['APPLICATION_HOST']}/github_events", content_type: 'json' } }
  let(:webook_options) { { events: ["membership"], active: true } }
  let(:webhook_create_response) { double(:webhook_create_response) }

  def build(*_args)
    described_class.new(*_args)
  end

  def service
    build(token: token, organization: organization)
  end

  before do
    allow(BuildOctokitClient).to receive(:for).with(token: token).and_return(client)
  end

  describe "#set" do
    context "when webhook does not exist" do
      before do
        allow(client).to receive(:create_org_hook).with("Platanus", webook_config, webook_options)
                                                  .and_return(webhook_create_response)
      end

      it 'creates the webhook' do
        expect(service.set).to eq(true)
      end
    end

    context "when webhook exists" do
      before do
        allow(client).to receive(:create_org_hook).with("Platanus", webook_config, webook_options)
                                                  .and_raise(Octokit::UnprocessableEntity)
      end

      it 'creates the webhook' do
        expect(service.set).to eq(false)
      end
    end
  end
end
