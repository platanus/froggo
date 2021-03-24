class GithubAuthController < ApplicationController
  def oauth_request
    github_session.clean_session
    redirect_to root_path
  end

  def authenticate!
    redirect_to GetGithubAuthUrl.for(callback_action: :login, client_type: :member)
  end

  def admin_authenticate!
    redirect_to GetGithubAuthUrl.for(callback_action: :settings, client_type: :admin,
                                     callback_params: { gh_org: permitted_params[:gh_org] })
  end

  def organization_authenticate!
    if delete_application_grant
      redirect_to GetGithubAuthUrl.for(callback_action: :add_organization, client_type: :member)
    end
  end

  def callback
    set_session_gh_access
    create_organizations_membership
    if permitted_params[:callback_action] == 'settings'
      redirect_to settings_organization_path(name: permitted_params[:gh_org])
    elsif permitted_params[:callback_action] == 'add_organization'
      redirect_to user_path(github_user) || organizations_path
    else
      redirect_to user_path(github_user) || organizations_path
    end
  end

  private

  def permitted_params
    params.permit(:client_type, :callback_action, :gh_org)
  end

  def create_organizations_membership
    gh_organization_ids = github_session.organizations.pluck(:id)
    Organization.where(gh_id: gh_organization_ids).each do |organization|
      OrganizationMembership.find_or_create_by!(
        organization: organization,
        github_user: github_session.user
      )
    end
  end

  def set_session_gh_access
    session_code = request.query_parameters['code']
    result = Octokit.exchange_code_for_token(session_code, ENV['GH_AUTH_ID'], ENV['GH_AUTH_SECRET'])
    github_session.set_session(result[:access_token], permitted_params[:client_type])
  end

  def delete_application_grant
    Octokit.client_id = ENV['GH_AUTH_ID']
    Octokit.client_secret = ENV['GH_AUTH_SECRET']
    Octokit.client.as_app do |client|
      client.delete("/applications/#{ENV['GH_AUTH_ID']}/grant", {
                      access_token: github_session.token
                    })
    end
    true
  rescue Octokit::ApplicationCredentialsRequired, Octokit::Unauthorized
    false
  end
end
