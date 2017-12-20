require 'rails_helper'

describe RepositoryService do
  let(:organization) { create(:organization, gh_id: 7649605) }
  let(:partial_payload) do
    {
      repository: {
        id: 27496774,
        name: 'new-repository',
        full_name: 'baxterandthehackers/new-repository',
        url: 'https://api.github.com/repos/baxterandthehackers/new-repository',
        html_url: 'https://github.com/baxterandthehackers/new-repository'
      },
      organization: {
        id: organization.gh_id
      }
    }
  end

  def build(payload)
    described_class.new(payload: payload)
  end

  context "on create" do
    let(:payload) { { **partial_payload, action: 'created' } }

    it "calls create_repository" do
      expect_any_instance_of(described_class).to(
        receive(:create_repository)
      )
      build(payload).process
    end

    it "creates repo" do
      build(payload).process
      expect(
        Repository.where(
          gh_id: payload[:repository][:id],
          name: payload[:repository][:name],
          full_name: payload[:repository][:full_name],
          tracked: false,
          url: payload[:repository][:url],
          html_url: payload[:repository][:html_url]
        )
      ).to exist
    end
  end

  context "on delete" do
    let(:payload) { { **partial_payload, action: 'deleted' } }

    it "calls create_repository" do
      expect_any_instance_of(described_class).to(
        receive(:delete_repository)
      )
      build(payload).process
    end

    it "destroys repo" do
      build(payload).process

      expect(
        Repository.where(
          gh_id: payload[:repository][:id],
          name: payload[:repository][:name],
          full_name: payload[:repository][:full_name],
          tracked: false,
          url: payload[:repository][:url],
          html_url: payload[:repository][:html_url]
        )
      ).not_to exist
    end
  end
end
