require 'rails_helper'

RSpec.describe WebhookController, type: :controller do
  describe "POST #receive" do
    let(:post_params) { { payload: '{}' } }
    let(:hook_secret) { 'hook-secret' }
    let(:x_hub_signature) do
      'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), hook_secret,
        post_params.to_json)
    end
    before do
      allow(ENV).to receive(:fetch).with('GH_HOOK_SECRET').and_return(hook_secret)
    end

    it "returns json success" do
      @request.headers['X-Hub-Signature'] = x_hub_signature
      post :receive, body: post_params.to_json, format: :json
      expect(response).to have_http_status(200)
    end
  end
end
