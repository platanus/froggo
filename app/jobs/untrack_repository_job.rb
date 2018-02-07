class UntrackRepositoryJob < ApplicationJob
  def perform(repository, token)
    RepositoryTrackingService.new(repository: repository, token: token).untrack
  end
end
