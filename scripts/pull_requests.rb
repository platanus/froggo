require 'octokit'

@client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
@client.auto_paginate = true

# Change filter and limit to change pull requests scope
repo_filter = {full_name: 'platanus/csp'}
repo_limit = 5

repos = Repository.where(repo_filter).limit(repo_limit)
repos_count = repos.count
repos.each_with_index do |repo, repo_num|
  puts "Reading rep ##{repo.gh_id} #{repo.full_name}...#{repo_num + 1} of #{repos_count}"

  pull_requests = @client.pull_requests(repo.full_name, state: 'all')

  puts 'Empty repo' if pull_requests.empty?

  pull_requests.each do |pr|
    PullRequest.create!(
      gh_id: pr.id,
      title: pr.title,
      gh_number: pr.number,
      pr_state: pr.state,
      html_url: pr.html_url,
      gh_created_at: pr.created_at,
      gh_updated_at: pr.updated_at,
      gh_closed_at: pr.closed_at,
      gh_merged_at: pr.merged_at,
      repository_id: repo.id
    )

  end
end
