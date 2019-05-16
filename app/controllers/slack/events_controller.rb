class Slack::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    handle_event(JSON.parse(request.body.read))
  end

  private

  def handle_event(data)
    case data['type']
    when 'url_verification'
      respond_slack_verification_challenge(data)
    end
  end

  def respond_slack_verification_challenge(data)
    render json: { challenge: data['challenge'] }, status: :ok
  end
end
