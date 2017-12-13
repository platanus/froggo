class AddRepositoryToPullRequest < ActiveRecord::Migration[5.1]
  def change
    add_reference :pull_requests, :repository, foreign_key: true
  end
end
