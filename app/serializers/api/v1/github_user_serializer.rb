class Api::V1::GithubUserSerializer < ActiveModel::Serializer
  attributes :id, :description, :name, :tags, :login, :avatar_url

  attribute :active, if: :froggo_team?
  attribute :percentage, if: :froggo_team?

  def tags
    object.tags.map do |tag|
      Api::V1::TagSerializer.new(tag)
    end
  end

  def froggo_team_membership
    object.froggo_team_memberships&.find_by(froggo_team: froggo_team)
  end

  def froggo_team?
    froggo_team.present?
  end

  def froggo_team
    @instance_options[:froggo_team]
  end

  def active
    froggo_team_membership.is_member_active
  end

  def percentage
    froggo_team_membership.assignment_percentage
  end
end
