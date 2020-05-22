class Slack::CommandsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_slack_token

  def create
    render json: { text: commands_service.reply }, status: :ok
  end

  private

  def commands_service
    @commands_service ||= SlackCommandsService.new(params: params)
  end

  def verify_slack_token
    return render json: {}, status: :forbidden unless ENV['SLACK_API_TOKEN'] == params['token']
  end
end
