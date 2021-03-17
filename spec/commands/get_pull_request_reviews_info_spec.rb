require 'rails_helper'

describe GetPullRequestReviewsInfo do
  let(:github_user) { create(:github_user) }
  let(:monkeyci) { create(:github_user, login: 'monkeyci') }
  let(:pull_request) { create(:pull_request, owner: github_user) }

  def perform(*_args)
    described_class.for(*_args)
  end

  context "when pull request doesn't have any reviews" do
    it "return empty" do
      expect(perform(pull_request: pull_request)).to be_empty
    end
  end

  context "when pull request has reviews" do
    context "when pull request has a review from monkeyci" do
      let!(:monkey_review) do
        create(
          :pull_request_review,
          github_user: monkeyci,
          pull_request: pull_request,
          created_at: (Time.zone.now - 5.minutes).to_s,
          approved_at: (Time.zone.now + 2.minutes).to_s
        )
      end
      let!(:human_review) do
        create(
          :pull_request_review,
          github_user: github_user,
          pull_request: pull_request,
          created_at: (Time.zone.now - 3.minutes).to_s,
          approved_at: Time.zone.now.to_s
        )
      end

      it "ignores monkey review" do
        expect(perform(pull_request: pull_request)).to eq(
          first_response: human_review.created_at,
          last_approval: human_review.approved_at
        )
      end
    end

    context "when pull request doesn't have approval information" do
      let!(:incomplete_review) do
        create(
          :pull_request_review,
          github_user: github_user,
          pull_request: pull_request,
          created_at: (Time.zone.now - 3.minutes).to_s
        )
      end

      it "ignores missing review information" do
        expect(perform(pull_request: pull_request)).to eq(
          first_response: incomplete_review.created_at
        )
      end
    end
  end
end
