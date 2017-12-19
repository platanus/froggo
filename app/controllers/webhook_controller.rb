class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @event = JSON.parse($redis.get('last event'))
    manage_request(@event) # <- comentar esta cuando este listo
    render json: {
      action: @event['action'],
      user: $redis.get('user'),
      response: @event,
      status: 200
    }, status: 200
  end

  def receive
    @event = request.body.read
    if verify_signature(request)
      # manage_request(JSON.parse(@event)) # <- Giovanni aquí llamar
      $redis.set('last event', @event)
      render json: { response: "ok", status: 200 }, status: 200
    else
      render json: { error: "not auth", status: 401 }, status: 401
    end
  end

  def manage_request(request)
    if request['action'] == 'review_requested'
      p request['pull_request']['id']
      p request['pull_request']['state']
      p request['pull_request']['user']['login']
      p request['pull_request']['user']['id']
      p request['pull_request']['user']['avatar_url']
      p request['pull_request']['user']['html_url']
      request['pull_request']['requested_reviewers'].each do |reviewer|
        p reviewer['login']
        p reviewer['id']
        p reviewer['avatar_url']
        p reviewer['html_url']
      end
      p request['pull_request']['head']['repo']['id']
      p request['pull_request']['head']['repo']['full_name']
      p request['pull_request']['head']['repo']['owner']['login']
      p request['pull_request']['head']['repo']['owner']['id']
    end
  end

  def verify_signature(request)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
      ENV['GH_HOOK_SECRET'], request.body.read)
    Rack::Utils.secure_compare(signature, request.headers['X-Hub-Signature'])
  end
end
