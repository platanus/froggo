class Untrack < PowerTypes::Command.new(:repo)
  def perform
    destroy_hook(@repo.hooks)
    destroy_pull_requests(PullRequest.where(repository_id: @repo.id))
  end

  private

  def destroy_hook(hooks)
    return false if hooks.empty?
    hooks.destroy_all
  end

  def destroy_pull_requests(pull_requests)
    return false if pull_requests.empty?
    pull_requests.each do |pr|
      pr.pull_request_relations.destroy_all
    end
    pull_requests.destroy_all
  end
end
