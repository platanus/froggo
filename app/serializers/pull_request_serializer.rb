class PullRequestSerializer < ActiveModel::Serializer
  attributes :id, :gh_id, :title, :gh_number, :pr_state, :html_url, :gh_created_at, :gh_updated_at, :gh_closed_at, :gh_merged_at, :created_at, :updated_at, :repository_id, :owner_id, :merged_by_id

  belongs_to :repository
  has_many :tils
end
