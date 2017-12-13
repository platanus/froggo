class CreatePullRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :pull_requests do |t|
      t.integer :gh_id
      t.string :title
      t.integer :gh_number
      t.string :pr_state
      t.string :html_url
      t.datetime :gh_created_at
      t.datetime :gh_updated_at
      t.datetime :gh_closed_at
      t.datetime :gh_merged_at

      t.timestamps
    end
  end
end
