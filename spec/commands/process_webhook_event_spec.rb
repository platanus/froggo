require 'rails_helper'

describe ProcessWebhookEvent do
  def perform(*_args)
    described_class.for(*_args)
  end

  context 'pull requests event' do
    let!(:event) { 'pull_request' }
    let!(:request) { {} }

    before do
      expect_any_instance_of(PullRequestService).to receive(:process).and_return(nil)
    end

    it 'call perform in pull request service' do
      ProcessWebhookEvent.for(request: request, event: event)
    end
  end

  context 'pull request reviews event' do
    let!(:event) { 'pull_request_review' }
    let!(:request) { {} }

    before do
      expect_any_instance_of(PullRequestReviewService).to receive(:process).and_return(nil)
    end

    it 'call perform in pull request review service' do
      ProcessWebhookEvent.for(request: request, event: event)
    end
  end
end
