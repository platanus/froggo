class Api::V1::OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :gh_id, :login, :description, :html_url, :avatar_url,
             :name, :tracked, :public_enabled, :default_team_id
end
