class DashboardController < ApplicationController
  def index
    @users = GithubUser.where(tracked: true)
    @corrmat = CorrelationMatrix.new(@users)
    @corrmat.fill_matrix
  end

  def get_owners_column(users)
    PullRequest.where(owner_id: users.pluck(:id))
  end
end

class CorrelationMatrix
  attr_accessor :row_head, :col_head, :data

  def initialize(users)
    @row_head = users
    @col_head = users
    @data = Hash.new(0)
  end

  def update_data(user1, user2)
    @data[[@row_head.find_index(user1), @col_head.find_index(user2)]] += 1
  end

  def fill_matrix
    PullRequest.where(owner_id: @col_head.pluck(:id)).each do |pr|
      pr.reviewers.each do |reviewer|
        update_data(pr.owner, reviewer)
      end
      pr.assignees.each do |assignee|
        update_data(pr.owner, assignee)
      end
    end
  end
end
