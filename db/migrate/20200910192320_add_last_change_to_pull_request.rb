class AddLastChangeToPullRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_requests, :last_change, :datetime
  end
end
