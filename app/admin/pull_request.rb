ActiveAdmin.register PullRequest do
  actions :all, except: [:new, :create, :edit, :update, :destroy]
  belongs_to :repository, optional: true
  menu priority: 5

  preserve_default_filters!
  filter :owner, collection: -> { GithubUser.all.pluck(:login, :id) }

  index do
    column :id
    column :gh_id
    column :title
    column :gh_number
    column :repository
    column :owner do |pr|
      link_to pr.owner.login, admin_github_user_path(pr.owner_id)
    end
    column :pr_state
    column :html_url
    column :relations do |pr|
      link_to t('active_admin.pull_request_relations', count: pr.pull_request_relations.count),
        admin_pull_request_pull_request_relations_path(pr)
    end
    column :gh_created_at

    actions
  end
end
