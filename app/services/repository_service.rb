class RepositoryService < PowerTypes::Service.new(:payload)
  def process
    case @payload[:action]
    when 'created'
      create_repository
    when 'deleted'
      delete_repository
    end
  end

  def create_repository
    repo
  end

  def delete_repository
    repo&.destroy
  end

  def repo_params
    {
      gh_id: @payload[:repository][:id],
      name: @payload[:repository][:name],
      full_name: @payload[:repository][:full_name],
      tracked: false,
      url: @payload[:repository][:url],
      html_url: @payload[:repository][:html_url],
      organization: organization
    }
  end

  def repo
    @repo ||= Repository.create_with(repo_params)
                        .find_or_create_by(gh_id: repo_params[:gh_id])
  end

  def organization
    @organization ||= Organization.find_by(gh_id: @payload[:organization][:id])
  end
end
