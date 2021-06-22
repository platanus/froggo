class Api::V1::PreferenceSerializer < ActiveModel::Serializer
  attributes :github_user_id, :default_organization_id, :default_team_id, :default_time
end
