class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: { response: JSON.parse($redis.get('last event')), status: 200 }, status: 200
  end

  def receive
    $redis.set('last event', request.body.to_json)
    if request["X-Hub-Signature"] == ENV["GH_HOOK_SECRET"]
      render json: { response: "ok", status: 200 }, status: 200
    end
    render json: { error: "not auth", status: 401 }, status: 401
  end
end
