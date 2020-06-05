class Api::V1::RepositoriesController < Api::V1::BaseController
  before_action :authenticate_github_user
  before_action :ensure_organization_admin

  def update
    process_tracked_update if tracked_changed?
    respond_with repository, status: 202
  end

  private

  def repository
    @repository ||= Repository.find(params[:id])
  end

  def github_organization
    github_session.organizations.find { |org| org[:id] == repository.organization[:gh_id] }
  end

  def ensure_organization_admin
    respond_api_error(401, message: "not_authorized") unless github_organization[:role] == "admin"
  end

  def tracked_changed?
    repository.tracked != params[:tracked]
  end

  def process_tracked_update
    if repository.tracked
      UntrackRepositoryJob.perform_later(repository, github_session.token)
    else
      TrackRepositoryJob.perform_later(repository, github_session.token)
    end
  end
end
