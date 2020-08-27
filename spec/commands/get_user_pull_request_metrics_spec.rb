require 'rails_helper'

describe GetUserPullRequestMetrics do
  let(:github_user) { create(:github_user) }
  let!(:monkeyci) { create(:github_user, login: 'monkeyci') }

  def perform(*_args)
    described_class.for(*_args)
  end

  context "without pull request" do
    it "return empty content" do
      expect(perform(github_user: github_user, limit_month: 9)).to eq(
        "personal_mean" => 0,
        "pull_requests_information" => {}
      )
    end
  end

  context "with pull request and review request" do
    let(:valid_pull_request) do
      create(
        :pull_request_with_merge,
        owner: github_user,
        gh_created_at: Time.zone.now - 5.minutes
      )
    end
    let!(:valid_review_request) do
      create(
        :pull_request_review_request,
        pull_request: valid_pull_request,
        created_at: Time.zone.now - 3.minutes
      )
    end

    context "with valid date limit" do
      it "return correct information" do
        expect(perform(github_user: github_user, limit_month: 9)).to eq(
          "pull_requests_information" => { valid_pull_request.id => {
            pr_created_at: valid_pull_request.gh_created_at.to_s,
            pr_title: "Prueba",
            review_request_created_at: valid_review_request.created_at.to_s,
            time_delta: 120
          } }, "personal_mean" => 120
        )
      end
    end

    context "with review request from monkeyci" do
      let!(:monkey_review_request) do
        create(
          :pull_request_review_request,
          github_user: monkeyci,
          pull_request: valid_pull_request,
          created_at: Time.zone.now - 4.minutes
        )
      end

      it "ignores review request from monkey" do
        expect(perform(github_user: github_user, limit_month: 9)).to eq(
          "pull_requests_information" => { valid_pull_request.id => {
            pr_created_at: valid_pull_request.gh_created_at.to_s,
            pr_title: "Prueba",
            review_request_created_at: valid_review_request.created_at.to_s,
            time_delta: 120
          } }, "personal_mean" => 120
        )
      end
    end

    context "with old pull request" do
      let(:old_pull_request) do
        create(
          :pull_request_with_merge,
          owner: github_user,
          gh_created_at: Time.zone.now - 1.year
        )
      end
      let!(:old_review_request) do
        create(
          :pull_request_review_request,
          pull_request: old_pull_request,
          created_at: Time.zone.now - 1.year
        )
      end

      it "ignores old pull request" do
        expect(perform(github_user: github_user, limit_month: 9)).to eq(
          "pull_requests_information" => { valid_pull_request.id => {
            pr_created_at: valid_pull_request.gh_created_at.to_s,
            pr_title: "Prueba",
            review_request_created_at: valid_review_request.created_at.to_s,
            time_delta: 120
          } }, "personal_mean" => 120
        )
      end
    end
  end
end
