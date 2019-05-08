class Github::OrganizationWebhookService < PowerTypes::Service.new(:organization, :token)
  def set
    client.create_org_hook(@organization.login, hook_config, hook_options)
    true
  rescue Octokit::UnprocessableEntity => e
    false
  end

  private

  def hook_config
    {
      url: "#{ENV['APPLICATION_HOST']}/github_events",
      content_type: 'json'
    }
  end

  def hook_options
    {
      events: ["membership"],
      active: true
    }
  end

  def client
    @client ||= BuildOctokitClient.for(token: @token)
  end
end
