class Api::V1::FroggoTeamMembershipSerializer < ActiveModel::Serializer
  attributes :id, :github_user_id, :froggo_team_id, :is_member_active
end
