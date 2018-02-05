require 'rails_helper'

describe CreatePullRelations do
  def perform(*_args)
    described_class.for(*_args)
  end

  describe "receive PR" do
    context "without any review and not merged" do
      let(:pull_request) { create(:pull_request) }
      it "doesn't create any relations" do
        expect { perform(pull_request: pull_request) }.not_to(
          change { PullRequestRelation.count }
        )
      end
    end

    context "with merge data" do
      let(:pull_request) { create(:pull_request_with_merge) }
      it "creates merged_by pull request relation" do
        expect { perform(pull_request: pull_request) }.to(
          change do
            PullRequestRelation.by_pull_request(pull_request.id).merged_relations.count
          end.by(1)
        )
      end
    end

    context "with reviews" do
      let(:pull_request) { create(:pull_request_with_reviews, reviews_count: 3) }
      it "creates reviewer pull request relation" do
        expect { perform(pull_request: pull_request) }.to(
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
        expect { perform(pull_request: pull_request) }.to(
          change do
            PullRequestRelation.by_pull_request(pull_request.id).review_relations.count
          end.by(1)
        )
      end
    end
  end
end
