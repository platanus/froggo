class CorrelationMatrix
  attr_accessor :row_head, :col_head, :data

  def initialize(org_gh_id)
    @organization = Organization.find_by(gh_id: org_gh_id)
    users = @organization.all_tracked_users
    @row_head = users
    @col_head = users
    @pos_hash = Hash[users.map(&:id).map.with_index { |x, i| [x, i] }]
    @data = Hash.new(0)
  end

  def fill_matrix
    @row_head.each_with_index do |user, index|
      user.interactions(@organization.id).each do |key, value|
        @data[[index, @pos_hash[key]]] += value
      end
      @data[[index, index]] = user_alone_prs(user)
    end
  end

  def user_alone_prs(user)
    merged_pr_ids = user.merged_pull_requests(@organization.id).pluck(:id)
    coop_pr_count = user.coop_pull_requests(merged_pr_ids, @organization.id).length
    merged_pr_ids.length - coop_pr_count
  end
end
