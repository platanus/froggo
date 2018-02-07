class TrackRepositoryJob < ApplicationJob
  def perform(repository, token)
    RepositoryTrackingService.new(repository: repository, token: token).track
  end
end
