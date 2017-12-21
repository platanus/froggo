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

  def fetch_repository_pull_requests(repo_full_name, token)
    c = client(token)
    c.pull_requests(repo_full_name, state: 'all')
  end

  def fetch_pull_request_reviews(repo_full_name, pull_rq_num, token)
    c = client(token)
    c.pull_request_reviews(repo_full_name, pull_rq_num,
      accept: 'application/vnd.github.thor-preview+json')
  end

  def fetch_repository_commit(repo_full_name, commit_sha, token)
    c = client(token)
    c.commit(repo_full_name, commit_sha)
  end

  def client(token)
    @client ||= begin
      c = Octokit::Client.new(access_token: token)
      c.auto_paginate = true
      c
    end
  end
end
