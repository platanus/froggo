class HookService < PowerTypes::Service.new
  # Service code goes here
  # @client.remove_hook('platanus/gh-pr-stats', 18934340)
  # @client.hooks('platanus/gh-pr-stats')

  def subscribe(repo)
    @hook = Hook.find_by(repository_id: repo.id)
    if @hook
      edit_active_hook(repo, @hook, true)
    else
      create_new_hook(repo)
    end
  end

  def unsubscribe(repo)
    @hook = Hook.find_by(repository_id: repo.id)
    edit_active_hook(repo, @hook, false)
  end

  private

  def create_new_hook(repo)
    @client = Octokit::Client.new(login: ENV["GH_L"], password: ENV["GH_P"])
    response = @client.create_hook(
      repo.full_name,
      'web',
      {
        url: "https://ghpr1234test.localtunnel.me/webhook/receive", # TO DO: repo url
        content_type: 'json'
      },
      {
        events: ['push', 'pull_request'],
        active: true
      }
    )
    create(response, repo)
  end

  def edit_active_hook(repo, hook, status)
    @client = Octokit::Client.new(login: ENV["GH_L"], password: ENV["GH_P"])
    @client.edit_hook(
      repo.full_name,
      hook.gh_id,
      'web',
      {
        url: "https://ghpr1234test.localtunnel.me/webhook/receive", # TO DO: repo url
        content_type: 'json',
        secret: ENV['GH_HOOK_SECRET']
      },
      {
        active: status
      }
    )
    hook.active = status
    hook.save
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
end
