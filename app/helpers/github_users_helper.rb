module GithubUsersHelper
  # Converts a list of teams, as retrived by
  # GithubUserService#fetch_teams_for_user to a list of teams compatible
  # with the `clickable-dropdown` Vue component.
  def convert_teams_to_clickable_dropdown_items(teams)
    teams.map do |team|
      { id: team[:id], name: team[:name] }
    end
  end
end
