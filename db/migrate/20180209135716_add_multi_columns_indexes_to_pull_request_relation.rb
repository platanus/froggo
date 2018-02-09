class AddMultiColumnsIndexesToPullRequestRelation < ActiveRecord::Migration[5.1]
  def change
    add_index :pull_request_relations, [:organization_id, :gh_updated_at, :github_user_id,
                                        :target_user_id],
              name: 'index_pr_relations_on_orgs_and_updated_and_all_users'
    add_index :pull_request_relations, [:organization_id, :gh_updated_at, :github_user_id,
                                        :pull_request_id],
              name: 'index_pr_relations_on_orgs_and_updated_and_user_and_prs'
  end
end
