require 'rails_helper'

describe PullRequestRelationService do
  def build(*_args)
    described_class.new(*_args)
  end

  let(:service) { build(pull_request: pull_request) }

  describe "#create_merge_relation" do
    context "without merged data" do
      let(:pull_request) { create(:pull_request) }
      it "doesn't create any relations" do
        expect { service.create_merge_relation }.not_to(
          change { PullRequestRelation.count }
        )
      end
    end

    context "with merge data" do
      let(:pull_request) { create(:pull_request_with_merge) }
      it "creates merged_by pull request relation" do
        expect { service.create_merge_relation }.to(
          change do
            PullRequestRelation.by_pull_request(pull_request.id).merged_relations.count
          end.by(1)
        )
      end

      it "creates merge relations correctly" do
        service.create_merge_relation
        pr_relation = PullRequestRelation.by_pull_request(pull_request.id).merged_relations.first
        expect(pr_relation).to have_attributes(
          pull_request: pull_request,
          github_user: pull_request.merged_by,
          organization_id: pull_request.repository.organization_id,
          gh_updated_at: pull_request.gh_merged_at,
          target_user_id: pull_request.owner_id
        )
      end
    end
  end

  describe "#create_review_relations" do
    context "without any review" do
      let(:pull_request) { create(:pull_request) }
      it "doesn't create any relations" do
        expect { service.create_review_relations }.not_to(
          change { PullRequestRelation.count }
        )
      end
    end

    context "with reviews" do
      let(:pull_request) { create(:pull_request_with_reviews, reviews_count: 3) }
      it "creates reviewer pull request relation" do
        expect { service.create_review_relations }.to(
          change do
            PullRequestRelation.by_pull_request(pull_request.id).review_relations.count
          end.by(3)
        )
      end
    end

    context "with reviews from the same github user" do
      let(:pull_request) { create(:pull_request) }
      let(:github_user) { create(:github_user) }
      before do
        3.times { pull_request.pull_request_reviews.create(github_user: github_user) }
      end
      it "creates only one review relation" do
        expect { service.create_review_relations }.to(
          change do
            PullRequestRelation.by_pull_request(pull_request.id).review_relations.count
          end.by(1)
        )
      end
    end
  end
end
