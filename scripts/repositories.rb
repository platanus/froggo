require 'octokit'
require 'json'

@client = Octokit::Client.new(ENV["GITHUB_USER"], password: ENV["GITHUB_PASS"])
@client.auto_paginate = true
@repositories = @client.org_repos('platanus')

File.open("db/repositories.json", "w") do |f|
  f.write(@repositories.map(&:to_h).to_json)
end
