class RecommendationBehaviourMatrix
  attr_accessor :organization_members, :data

  def initialize(organization_id)
    @organization = Organization.find(organization_id)
    @organization_members = @organization.members
    @data = Hash.new(0)
  end

  def fill_matrix
    users_ids = @organization_members.map(&:id)
    map_user_id_to_index =
      Hash[users_ids.map.with_index { |user_id, index| [user_id, index] }]
    map_user_id_to_index.each do |user_id_and_index|
      fill_row(user_id_and_index[0], user_id_and_index[1])
    end
  end

  private

  def fill_row(user_id, user_index)
    user_statistics = ComputeUserStatistics.for(
      github_user_id: user_id,
      organization_id: @organization.id
    )
    @data[[user_index, 0]] = user_statistics[:obedient]
    @data[[user_index, 1]] = user_statistics[:indifferent]
    @data[[user_index, 2]] = user_statistics[:rebel]
  end
end
