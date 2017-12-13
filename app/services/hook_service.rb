class HookService < PowerTypes::Service.new
  # Service code goes here
  # @client.remove_hook('platanus/gh-pr-stats', 18934239)
  # @client.hooks('platanus/gh-pr-stats')
  def subscribe(repo)
    @client = Octokit::Client.new(login: ENV["GH_L"], password: ENV["GH_P"])
    response = @client.create_hook(
      repo.full_name,
      'web',
      {
        url: 'https://hcfophqxoj.localtunnel.me/webhook/receive', # TO DO: custom url
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
      repo_type: response[:type],
      gh_id: response[:id],
      name: response[:name],
      active: response[:active],
      ping_url: response[:ping_url],
      test_url: response[:test_url]
    )
  end
end
