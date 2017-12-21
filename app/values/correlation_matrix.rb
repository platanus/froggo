class CorrelationMatrix
  attr_accessor :row_head, :col_head, :data

  def initialize(users)
    @row_head = users
    @col_head = users
    @data = Hash.new(0)
  end

  def update_data(user1, user2)
    i = @row_head.find_index(user1)
    j = @col_head.find_index(user2)
    @data[[i, j]] += 1 unless i.nil? || j.nil?
  end

  def fill_matrix(pull_requests)
    pull_requests.each do |pr|
      pr.reviewers.each do |reviewer|
        update_data(pr.owner, reviewer)
      end
      pr.assignees.each do |assignee|
        update_data(pr.owner, assignee)
      end
    end
  end
end
