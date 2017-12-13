class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  # TO DO: change for the real GithubServer
  def index
    @gh_last = Rails.cache.read 'last event'
  end

  def receive
    Rails.cache.write 'last event', request.raw_post
  end
end
