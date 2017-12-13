module OctokitClient
  extend self

  def fetch_organizations(token)
    return if token.nil?
    c = client(token)
    c.orgs.map { |o| c.org o[:login] }
  end

  def fetch_organization_repositories(org_name, token)
    return if token.nil?
    c = client(token)
    c.org_repos(org_name)
  end

  def client(token)
    @client ||= begin
      c = Octokit::Client.new(access_token: token)
      c.auto_paginate = true
      c
    end
  end
end
