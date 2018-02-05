class Api::V1::RepositoriesController < Api::V1::BaseController
  before_action :authenticate_github_user
  before_action :ensure_organization_admin

  def update
    respond_with repository
  end

  private

  def repository
    @repository ||= Repository.find(params[:id])
  end

  def github_organization
    @github_session.organizations.find { |org| org[:login] == repository.organization[:login] }
  end

  def ensure_organization_admin
    respond_api_error(401, "not_authorized", nil) unless github_organization[:role] == "admin"
  end
end
