class RepositorySerializer < ActiveModel::Serializer
  attributes :id, :gh_id, :name, :full_name, :tracked, :url, :html_url, :created_at, :updated_at, :organization_id, :gh_updated_at

  has_many :pull_requests, dependent: :destroy
end
