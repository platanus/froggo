class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @body = JSON.parse($redis.get('body')).deep_symbolize_keys
    ProcessWebhookEvent.for(request: @body, event: $redis.get('event'))
    render json: {
      action: @body[:action],
      response: @body,
      status: 200
    }, status: 200
  end

  def receive
    body = request.body.read
    event = request.headers['X-GitHub-Event']
    if verify_signature(request)
      ProcessWebhookEvent.for(request: JSON.parse(body).deep_symbolize_keys, event: event)
      $redis.set('body', @body)
      $redis.set('event', @event)
      render json: { response: "ok", status: 200 }, status: 200
    else
      render json: { error: "not auth", status: 401 }, status: 401
    end
  end

  def verify_signature(request)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
      ENV['GH_HOOK_SECRET'], request.body.read)
    Rack::Utils.secure_compare(signature, request.headers['X-Hub-Signature'])
  end
end
