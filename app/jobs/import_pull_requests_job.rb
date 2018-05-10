class ImportPullRequestsJob < ApplicationJob
  queue_as :pull_requests

  def perform(repository, page, token)
    GithubPullRequestService.new(token: token).import_page_from_repository(repository, page)
  end
end
