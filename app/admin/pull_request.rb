ActiveAdmin.register PullRequest do
  actions :all, except: [:new, :create, :edit, :update, :destroy]
  belongs_to :repository

  index do
    column :id
    column :gh_id
    column :title
    column :gh_number
    column :pr_state
    column :html_url
    column :gh_created_at
    column :gh_merged_at

    actions
  end
end
