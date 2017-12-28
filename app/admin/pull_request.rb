ActiveAdmin.register PullRequest do
  actions :all, except: [:new, :create, :edit, :update, :destroy]
  belongs_to :repository, optional: true
  menu priority: 5

  index do
    column :id
    column :gh_id
    column :title
    column :gh_number
    column :pr_state
    column :html_url
    column :relations do |pr|
      link_to t('active_admin.pull_request_relations', count: pr.pull_request_relations.count),
        admin_pull_request_pull_request_relations_path(pr)
    end
    column :gh_created_at
    column :gh_merged_at

    actions
  end
end
