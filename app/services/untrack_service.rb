class UntrackService < PowerTypes::Service.new(:repo)
  def destroy_entities
    destroy_hook(Hook.find_by(repository_id: @repo.id))
    destroy_pull_request(PullRequest.where(repository_id: @repo.id))
  end

  private

  def destroy_hook(hook)
    hook.destroy
  end

  def destroy_pull_request(pull_request)
    pull_request.each do |pr|
      PullRequestRelation.where(pull_request_id: pr.id).destroy_all
    end
    pull_request.destroy_all
  end
end
