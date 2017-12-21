class DashboardController < ApplicationController
  def index
    @corrmat = CorrelationMatrix.new(GithubUser.where(tracked: true))
    @corrmat.fill_matrix(PullRequest.where(owner_id: GithubUser.where(tracked: true).pluck(:id)))
  end
end
