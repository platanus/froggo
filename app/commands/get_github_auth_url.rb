class GetGithubAuthUrl < PowerTypes::Command.new(:callback_action, :client_type,
  callback_params: {})
  def perform
    client = Octokit::Client.new
    client.authorize_url(
      ENV['GH_AUTH_ID'],
      scope: client_scope,
      redirect_uri:
        Rails.application.routes.url_helpers.github_callback_url(
          @callback_params.merge(callback_action: @callback_action, client_type: @client_type)
        )
    )
  end

  def client_scope
    case @client_type
    when :admin
      'user,repo,admin:org,admin:repo_hook,admin:org_hook'
    when :member
      'read:user,read:org'
    else
      ''
    end
  end
end
