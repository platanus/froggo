class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  # TO DO: change for the real GithubServer
  def index; end

  def subscribe(repo)
    @client = Octokit::Client.new(login: "mf222", password: "ruryo521")
    response = @client.create_hook(
      repo.full_name,
      'web',
      {
        url: 'https://hcfophqxoj.localtunnel.me/webhook/receive',
        content_type: 'json'
      },
      {
        events: ['push', 'pull_request'],
        active: true
      }
    )
    create(response)
  end

  def create(response)
    @hook = Hook.create(
      type: response[:type],
      gh_id: response[:id],
      name: response[:name],
      active: response[:active],
      ping_url: response[:ping_url],
      test_url: response[:test_url]
    )
  end

  def unsubscribe(repo_id, hook_id); end

  def receive
    puts request.raw_post
  end
end
