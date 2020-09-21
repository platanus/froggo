class FroggoTeamObserver < PowerTypes::Observer
  after_destroy :update_default_team_id

  def update_default_team_id
    organization = object.organization
    if organization.default_team_id == object.id
      organization.update(default_team_id: nil)
    end
  end
end
