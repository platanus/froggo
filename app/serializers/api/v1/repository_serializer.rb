class Api::V1::RepositorySerializer < ActiveModel::Serializer
  attributes :id, :gh_id, :name, :full_name, :tracked, :url, :html_url, :organization_id
end
