class HookService < PowerTypes::Service.new
  # Service code goes here
  # @client.remove_hook('platanus/gh-pr-stats', 18934340)
  # @client.hooks('platanus/gh-pr-stats')
  def subscribe(repo)
    @client = Octokit::Client.new(login: ENV["GH_L"], password: ENV["GH_P"])
    hook = Hook.find_by(repository_id: repo.id)
    if hook
      @client.edit_hook(
        repo.full_name,
        hook.gh_id,
        'web',
        {
          url: 'https://hcfophqxoj.localtunnel.me/webhook/receive', # TO DO: custom url
          content_type: 'json'
        },
        {
          active: false
        }
      )
    else
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
      create(response, repo)
    end
  end

  def create(response, repo)
    @hook = Hook.create(
      repo_type: response[:type],
      gh_id: response[:id],
      name: response[:name],
      active: response[:active],
      ping_url: response[:ping_url],
      test_url: response[:test_url],
      repository_id: repo.id
    )
  end

  def unsubscribe(repo)
    @hook = Hook.find_by(repository_id: repo.id)
    @client = Octokit::Client.new(login: ENV["GH_L"], password: ENV["GH_P"])
    @client.edit_hook(
      repo.full_name,
      @hook.gh_id,
      'web',
      {
        url: 'https://hcfophqxoj.localtunnel.me/webhook/receive', # TO DO: custom url
        content_type: 'json'
      },
      {
        active: false
      }
    )
    @hook.active = false
    @hook.save
  end
end
