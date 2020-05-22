require 'rails_helper'

describe OrganizationCleanerService do
  let(:token) { 'blubli' }
  let(:service) { build(token: token) }
  let(:organization) { double }
  let(:pullRequestReviewService) { double(delete_prs_reviews: nil) }
  let(:pullRequestService) { double(delete_prs: nil) }
  let(:gh_ids) { double }
  let(:prs_ids) { double }
  let(:membershipService) do
    double(import_all_from_organization: nil,
           ex_members_ids: gh_ids,
           delete_ex_members: nil)
  end

  def build(*_args)
    described_class.new(*_args)
  end

  describe '#clean' do
    before do
      allow(service).to receive(:prs_ids_to_delete).and_return(prs_ids)
      allow(service).to receive(:delete_prs_relations).and_return(nil)
      allow(GithubPullRequestService).to receive(:new).and_return(pullRequestService)
      allow(GithubPullRequestReviewService).to receive(:new).and_return(pullRequestReviewService)
      allow(GithubOrgMembershipService).to receive(:new).and_return(membershipService)
    end

    it 'calls GithubPullRequestService#delete_prs' do
      expect(pullRequestService).to receive(:delete_prs).with(prs_ids)
      service.clean(organization)
    end

    it 'calls GithubPullRequestReviewService#delete_prs' do
      expect(pullRequestReviewService).to receive(:delete_prs_reviews).with(prs_ids)
      service.clean(organization)
    end

    it 'calls GithubOrgMembershipService#delete_ex_members' do
      expect(membershipService).to receive(:delete_ex_members)
        .with(organization, gh_ids).and_return(nil)
      service.clean(organization)
    end
  end

  describe '#prs_ids_to_delete' do
    let(:pull_request) { create(:pull_request) }
    context 'when ex_mems_gh_ids is a empty list' do
      let(:ex_mems_gh_ids) { [] }
      it 'returns an empty array' do
        expect(service.prs_ids_to_delete(ex_mems_gh_ids)).to eq([])
      end
    end

    context 'when ex_mems_gh_ids is not empty' do
      let!(:deleted_mem) { create(:github_user) }
      let!(:mem) { create(:github_user) }
      let(:ex_mems_gh_ids) { [deleted_mem.id] }
      context 'when exists related pr to delete' do
        let!(:pull_request1) { create(:pull_request, owner: deleted_mem) }
        let!(:pull_request2) { create(:pull_request, owner: mem) }
        let!(:pr_relation1) do
          create(:pull_request_relation, pull_request: pull_request1, github_user: deleted_mem)
        end
        let!(:pr_relation2) do
          create(:pull_request_relation, pull_request: pull_request2, github_user: mem)
        end

        it 'returns array with only related prs ids' do
          expect(service.prs_ids_to_delete(ex_mems_gh_ids)).to eq([pull_request1.id])
        end
      end

      context "when doesn't exist related pr to delete" do
        it 'returns an empty array' do
          expect(service.prs_ids_to_delete(ex_mems_gh_ids)).to eq([])
        end
      end
    end
  end

  describe '#delete_prs_relations' do
    context 'with no relations to delete' do
      let!(:pr_ids) { [] }
      it "doesn't delete any pull request review" do
        expect { service.delete_prs_relations(pr_ids) }.to \
          change { PullRequestRelation.count }.by(0)
      end
    end

    context 'with only one relations to delete' do
      let!(:gh_ids) { [10] }
      let(:pull_request1) { create(:pull_request, gh_id: gh_ids[0]) }
      let!(:pr_ids) { [pull_request1.id] }
      let!(:pr_review) do
        create(:pull_request_relation, pull_request: pull_request1)
      end

      it 'deletes pull request relations' do
        expect { service.delete_prs_relations(pr_ids) }.to \
          change { PullRequestRelation.count }.by(-1)
      end
    end

    context 'with more than one relations to delete' do
      let!(:gh_ids) { [10, 20, 30] }
      let(:pull_request1) { create(:pull_request, gh_id: gh_ids[0]) }
      let(:pull_request2) { create(:pull_request, gh_id: gh_ids[1]) }
      let(:pull_request3) { create(:pull_request, gh_id: gh_ids[2]) }
      let!(:pr_ids) { [pull_request1.id, pull_request2.id, pull_request3.id] }
      let!(:pr_relation) do
        create(:pull_request_relation, pull_request: pull_request1)
      end

      let!(:pr_relation2) do
        create(:pull_request_relation, pull_request: pull_request2)
      end

      let!(:pr_relation3) do
        create(:pull_request_relation, pull_request: pull_request3)
      end

      it 'deletes all pull requests reviews' do
        expect { service.delete_prs_relations(pr_ids) }.to \
          change { PullRequestRelation.count }.by(-3)
      end
    end
  end
end
