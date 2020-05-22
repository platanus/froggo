class BuildOctokitClient < PowerTypes::Command.new(:token, per_page: nil)
  def perform
    client = Octokit::Client.new(access_token: @token, per_page: @per_page)
    unless @per_page
      client.auto_paginate = true
    end
    client
  end
end
