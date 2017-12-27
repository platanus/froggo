class DashboardController < ApplicationController
  def index
    @corrmat = CorrelationMatrix.new(GithubUser.where(tracked: true))
    @corrmat.fill_matrix
  end
end
