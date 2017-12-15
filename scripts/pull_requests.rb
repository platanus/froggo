# Change filter and limit to change pull requests scope
repo_filter = {full_name: %w(platanus/csp platanus/pic-parks platanus/gh-pr-stats)}
repo_limit = 5

admin = AdminUser.all.first
gh_service = GithubService.new(user: admin)
repos = Repository.where(repo_filter).limit(repo_limit)
repos_count = repos.count
repos.each_with_index do |repo, repo_num|
  puts "Reading rep ##{repo.gh_id} #{repo.full_name}...#{repo_num + 1} of #{repos_count}"

  gh_service.create_repository_pull_requests(repo.id, repo.full_name)
end
