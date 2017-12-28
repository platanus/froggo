ActiveAdmin.register PullRequestRelation do
  actions :all, except: [:new, :create, :edit, :update, :destroy]
  belongs_to :pull_request, optional: true
  menu priority: 6

  index do
    column :id
    column :pull_request
    tag_column :pr_relation_type
    column :github_user do |pr_relation|
      link_to pr_relation.github_user.login, admin_github_user_path(pr_relation.github_user_id)
    end
    column :gh_created_at
    column :gh_merged_at

    actions
  end
end
