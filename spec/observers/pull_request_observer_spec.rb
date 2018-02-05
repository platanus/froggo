require 'rails_helper'

describe PullRequestObserver do
  describe "#update_pull_request_relations" do
    let(:pull_request) { create(:pull_request) }
    before do
      expect(CreatePullRelations).to receive(:for).and_return(nil)
    end

    it "calls CreatePullRelations when saved", observers: true do
      pull_request.update(merged_by: create(:github_user), gh_merged_at: Time.current)
    end
  end

  describe "#destroy_pull_request_relations" do
    let(:pull_request) { create(:pull_request) }
    before do
      create(:pull_request_relation, pull_request: pull_request)
    end

    it "destroy all pull request relations", observers: true do
      pull_request.destroy
      expect(PullRequestRelation.by_pull_request(pull_request.id)).to be_empty
    end
  end
end
