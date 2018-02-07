require 'rails_helper'

RSpec.describe Api::V1::RepositoriesController, type: :controller do
  let(:platanus_organization) { create(:organization) }
  let(:buda_organization) { create(:organization) }

  let(:github_session) do
    double(
      token: "token",
      organizations: [
        { id: platanus_organization.gh_id, role: "admin" },
        { id: buda_organization.gh_id, role: "member" }
      ]
    )
  end

  before do
    expect(subject).to receive(:authenticate_github_user).and_return(true)
    allow(subject).to receive(:github_session).and_return(github_session)
  end

  describe "#update" do
    let(:organization) { platanus_organization }
    let(:repository) { create(:repository, organization: organization, tracked: tracked) }
    let(:tracked) { false }

    context "when user is not admin of the organization" do
      let(:organization) { buda_organization }

      before do
        put :update, params: { id: repository.id, tracked: true }, format: :json
      end

      it { expect(response).to have_http_status(401) }
    end

    context "when user is admin of the organization" do
      before do
        allow(TrackRepositoryJob).to receive(:perform_later).and_return(true)

        put :update, params: { id: repository.id }, format: :json
      end

      it { expect(response).to have_http_status(202) }
    end

    context "when tracked param changed to true" do
      before do
        expect(TrackRepositoryJob).to receive(:perform_later).with(repository, "token")
                                                             .and_return(true)

        put :update, params: { id: repository.id, tracked: true }, format: :json
      end

      it { expect(response).to have_http_status(202) }
    end

    context "when tracked param changed to false" do
      let(:tracked) { true }

      before do
        expect(UntrackRepositoryJob).to receive(:perform_later).with(repository, "token")
                                                               .and_return(true)

        put :update, params: { id: repository.id, tracked: false }, format: :json
      end

      it { expect(response).to have_http_status(202) }
    end
  end
end
