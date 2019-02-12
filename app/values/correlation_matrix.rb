class CorrelationMatrix
  DEFAULT_MONTH_LIMIT = 9

  attr_accessor :selected_users, :data, :limit

  def initialize(org_id, user_ids, current_user, limit = DEFAULT_MONTH_LIMIT)
    @current_user = GithubUser.find_by(login: current_user)
    @limit = limit.present? ? limit : DEFAULT_MONTH_LIMIT
    @organization = Organization.find(org_id)
    @pr_relations = PullRequestRelation.by_organizations(org_id).within_month_limit(@limit)
    @selected_users = @organization.members
    @selected_users = @selected_users.where(gh_id: user_ids) if user_ids
    order_current_user if @current_user
    @data = Hash.new(0)
  end

  def fill_matrix
    amount_of_users = @selected_users.length
    users_ids = @selected_users.map(&:id)
    map_user_id_to_index =
      Hash[users_ids.map.with_index { |user_id, index| [user_id, index] }]
    current_user_id = users_ids.first
    other_users_ids = users_ids.drop(1)
    (0...amount_of_users).each do |next_swapped_index|
      fill_row(current_user_id, other_users_ids, map_user_id_to_index)
      unless next_swapped_index == amount_of_users - 1
        tmp = current_user_id
        current_user_id = other_users_ids[next_swapped_index]
        other_users_ids[next_swapped_index] = tmp
      end
    end
  end

  def min_ranking_indexes
    @min_ranking_indexes ||= ContributionRanker::RankContributions.for(
      users_contributions: @data,
      limit: 3
    )
  end

  private

  def fill_row(current_user_id, other_users_ids, map_user_id_to_index)
    current_user_contributions = ComputeGithubContributions.for(
      user_id: current_user_id,
      other_users_ids: other_users_ids,
      pr_relations: @pr_relations
    )
    current_user_row = map_user_id_to_index[current_user_id]
    @data[[current_user_row, current_user_row]] =
      current_user_contributions[:self_reviewed_prs]
    other_users_ids.each_with_index do |other_user_id, other_user_index|
      @data[[current_user_row, map_user_id_to_index[other_user_id]]] =
        current_user_contributions[:per_user_contributions][other_user_index]
    end
  end

  def order_current_user
    @selected_users = @selected_users.order("CASE WHEN github_users.id = #{@current_user.id}" \
                                              'THEN 1 ELSE 0 END DESC')
                                     .order('github_users.id ASC')
  end
end
