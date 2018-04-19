class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    body = request.body.read
    event = request.headers['X-GitHub-Event']
    if verify_signature(request)
      ProcessWebhookEvent.for(request: JSON.parse(body).deep_symbolize_keys, event: event)
      render json: { response: "ok", status: 200 }, status: 200
    else
      render json: { error: "not auth", status: 401 }, status: 401
    end
  end

  def verify_signature(request)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
      ENV.fetch('GH_HOOK_SECRET'), request.body.read)
    Rack::Utils.secure_compare(signature, request.headers['X-Hub-Signature'])
  end
end
