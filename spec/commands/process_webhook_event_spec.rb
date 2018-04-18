require 'rails_helper'

describe ProcessWebhookEvent do
  def perform(request, event)
    described_class.for(request: request, event: event)
  end

  context 'pull requests event' do
    let!(:event) { 'pull_request' }
    let!(:request) { {} }

    it 'calls process on pull request service' do
      expect_any_instance_of(GithubPullRequestService).to receive(:handle_webhook_event)
        .with(request)
      perform(request, event)
    end
  end

  context 'pull request reviews event' do
    let!(:event) { 'pull_request_review' }
    let!(:request) { {} }

    it 'calls process on pull request review service' do
      expect_any_instance_of(GithubPullRequestReviewService).to receive(:handle_webhook_event)
        .with(request)
      perform(request, event)
    end
  end
end
