class DashboardController < ApplicationController
  def index
    @corrmat = CorrelationMatrix.new(GithubUser.where(tracked: true))
    @corrmat.fill_matrix(PullRequest.where(owner_id: GithubUser.where(tracked: true).pluck(:id)))
  end

  def get_owners_column(users)
    PullRequest.where(owner_id: users.pluck(:id))
  end
end
