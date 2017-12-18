class HookService < PowerTypes::Service.new
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
    response = OctokitClient.client(repo.organization.owner.token).create_hook(
      repo.full_name,
      'web',
      {
        url: "#{ENV['APPLICATION_HOST']}/github_events",
        content_type: 'json',
        secret: ENV['GH_HOOK_SECRET']
      },
      events: ['push', 'pull_request'],
      active: true
    )
    create(response, repo)
  end

  def edit_active_hook(repo, hook, status)
    hook.active = status
    hook.save
    OctokitClient.client(repo.organization.owner.token).edit_hook(
      repo.full_name,
      hook.gh_id,
      'web',
      {
        url: "#{ENV['APPLICATION_HOST']}/github_events",
        content_type: 'json',
        secret: ENV['GH_HOOK_SECRET']
      },
      active: status
    )
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
