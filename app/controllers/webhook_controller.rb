class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: { last_event: JSON($redis.get('last event')) }
  end

  def receive
    $redis.set('last event', request.raw_post)
    last_event(request.raw_post)
    if request["X-Hub-Signature"] == ENV["GH_HOOK_SECRET"]
      render json: { response: "ok", status: 200 }, status: 200
    end
    render json: { error: "not auth", status: 401 }, status: 401
  end
end
