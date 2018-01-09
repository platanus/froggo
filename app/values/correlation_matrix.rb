class CorrelationMatrix
  attr_accessor :row_head, :col_head, :data

  def initialize(users)
    @row_head = users
    @col_head = users
    @pos_hash = Hash[users.map(&:id).map.with_index { |x, i| [x, i] }]
    @data = Hash.new(0)
  end

  def fill_matrix
    @row_head.each_with_index do |user, index|
      user.interactions.each { |key, value| @data[[index, @pos_hash[key]]] += value }
      @data[[index, index]] = user_alone_prs(user)
    end
  end

  def user_alone_prs(user)
    merged_pr_ids = user.merged_pull_requests.pluck(:id)
    coop_pr_count = user.coop_pull_requests(merged_pr_ids).length
    merged_pr_ids.length - coop_pr_count
  end
end
