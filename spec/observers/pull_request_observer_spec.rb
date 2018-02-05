require 'rails_helper'

describe PullRequestObserver, observers: true do
  describe "#update_pull_request_relations" do
    before do
      expect(CreatePullRelations).to receive(:for).and_return(nil)
    end

    context "when merge data is saved" do
      let(:pull_request) { create(:pull_request) }

      it "calls CreatePullRelations" do
        pull_request.update(merged_by: create(:github_user), gh_merged_at: Time.current)
      end
    end

    context "when review data is saved" do
      it "calls CreatePullRelations" do
        create(:pull_request_with_reviews, reviews_count: 1)
      end
    end
  end

  describe "#destroy_pull_request_relations" do
    let(:pull_request) { create(:pull_request) }
    before do
      create(:pull_request_relation, pull_request: pull_request)
    end

    it "destroy all pull request relations" do
      pull_request.destroy
      expect(PullRequestRelation.by_pull_request(pull_request.id)).to be_empty
    end
  end
end
