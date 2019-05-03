class RecommendationBehaviourMatrix
  attr_accessor :team_members, :data

  def initialize(organization_id, default_ids)
    @organization = Organization.find(organization_id)
    @team_members = @organization.members
    @team_members = @team_members.where(gh_id: default_ids) if default_ids
    @team_members = order_by_total_statistics
    @data = Hash.new(0)
  end

  def fill_matrix
    users_ids = @team_members.map(&:id)
    map_user_id_to_index =
      Hash[users_ids.map.with_index { |user_id, index| [user_id, index] }]
    map_user_id_to_index.each do |user_id_and_index|
      fill_row(user_id_and_index[0], user_id_and_index[1])
    end
  end

  private

  def fill_row(user_id, user_index)
    user_statistics = compute_user_statistics(user_id)
    @data[[user_index, 0]] = user_statistics[:obedient]
    @data[[user_index, 1]] = user_statistics[:indifferent]
    @data[[user_index, 2]] = user_statistics[:rebel]
  end

  def order_by_total_statistics
    @team_members.sort_by { |user| -compute_user_statistics(user.id)[:total] }
  end

  def compute_user_statistics(user_id)
    ComputeUserStatistics.for(
      github_user_id: user_id,
      organization_id: @organization.id
    )
  end
end
