require 'rails_helper'

describe PullRequestReviewObserver, observers: true do
  describe "#update_pull_request_relations" do
    let(:pull_request) { create(:pull_request) }
    let(:reviewer) { create(:github_user, login: 'reviewer') }

    it "calls service to create merge relation" do
      expect_any_instance_of(PullRequestRelationService).to receive(:create_review_relations)
        .and_return(nil)
      pull_request.pull_request_reviews.create(github_user: reviewer)
    end
  end
end
