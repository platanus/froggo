class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @body = JSON.parse($redis.get('body'))
    manage_request(@body, $redis.get('event')) # <- Comentar esta cuando este listo
    render json: {
      action: @body['action'],
      response: @body,
      status: 200
    }, status: 200
  end

  def receive
    @body = request.body.read
    @event = request.headers['X-GitHub-Event']
    if verify_signature(request)
      # manage_request(JSON.parse(@body, @event)) # <- Giovanni aquí llamar a metodos
      $redis.set('body', @body)
      $redis.set('event', @event)
      render json: { response: "ok", status: 200 }, status: 200
    else
      render json: { error: "not auth", status: 401 }, status: 401
    end
  end

  def manage_request(request, event)
    # Aquí llama a métodos para crear
    if event == 'pull_request' && request['action'] == 'assigned'
      show_some_attributes(request)
    elsif event == 'pull_request_review_comment'
      show_some_attributes(request)
    end
  end

  def show_some_attributes(request)
    p request['pull_request']['id']
    p request['pull_request']['state']
    p request['pull_request']['user']['login']
    p request['pull_request']['user']['id']
    p request['pull_request']['user']['avatar_url']
    p request['pull_request']['user']['html_url']
    p request['pull_request']['head']['repo']['id']
    p request['pull_request']['head']['repo']['full_name']
    p request['pull_request']['head']['repo']['owner']['login']
    p request['pull_request']['head']['repo']['owner']['id']
  end

  def verify_signature(request)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
      ENV['GH_HOOK_SECRET'], request.body.read)
    Rack::Utils.secure_compare(signature, request.headers['X-Hub-Signature'])
  end
end
