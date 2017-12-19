class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: { response: JSON.parse($redis.get('last event')), status: 200 }, status: 200
  end

  def receive
    $redis.set('last event', request.body.read)
    if verify_signature(request)
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
