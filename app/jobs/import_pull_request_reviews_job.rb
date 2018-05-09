class ImportPullRequestReviewsJob < ApplicationJob
  def perform(pull_request, token)
    GithubPullRequestReviewService.new(token: token).import_all_from_pull_request(pull_request)
  end
end
