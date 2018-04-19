class RemoveLastPullRequestModificationFromPullRequest < ActiveRecord::Migration[5.1]
  def change
    remove_column :repositories, :last_pull_request_modification
  end
end
