class GithubService < PowerTypes::Service.new(:user)
  def create_organizations
    if orgs = OctokitClient.fetch_organizations(@user.token)
      orgs.each do |o|
        organization = Organization.create_with(
          login: o[:login],
          name: o[:name]
        ).find_or_create_by(gh_id: o[:id])
        organization.update! description: o[:description],
                             tracked: false,
                             html_url: "https://github.com/#{o[:login]}/",
                             avatar_url: o[:avatar_url]
      end
    end
  end

  def create_organization_repositories(org_name)
    if repos = OctokitClient.fetch_organization_repositories(org_name, @user.token)
      repos.each do |r|
        repository = Repository.create_with(
          gh_id: r[:gh_id],
          full_name: r[:full_name]
        ).find_or_create_by! gh_id: r[:id]
        repository.update! name: r[:name],
                           full_name: r[:full_name],
                           url: r[:url],
                           html_url: r[:html_url]
      end
    end
  end
end
