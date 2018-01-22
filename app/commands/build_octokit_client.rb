class BuildOctokitClient < PowerTypes::Command.new(:token)
  def perform
    client = Octokit::Client.new(access_token: @token)
    client.auto_paginate = true
    client
  end
end
