class AddOwnerIdToPullRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :pull_requests, :owner_id, :integer
  end
end
