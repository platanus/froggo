ActiveAdmin.register PullRequestRelation do
  actions :all, except: [:new, :create, :edit, :update, :destroy]
  belongs_to :pull_request, optional: true
  menu priority: 6

  preserve_default_filters!
  filter :pull_request_owner_login, as: :select, label: 'Owner',
                                    collection: -> { GithubUser.all.pluck(:login) }
  filter :pull_request_repository_name, as: :select, label: 'Repository',
                                        collection: -> { Repository.all.pluck(:name) }

  index do
    column :id
    column :pull_request
    column :repository do |pr_relation|
      link_to pr_relation.pull_request.repository.name,
        admin_repository_path(pr_relation.pull_request.repository_id)
    end
    column :owner do |pr_relation|
      link_to pr_relation.pull_request.owner.login,
        admin_github_user_path(pr_relation.pull_request.owner_id)
    end
    tag_column :pr_relation_type
    column :github_user do |pr_relation|
      link_to pr_relation.github_user.login, admin_github_user_path(pr_relation.github_user_id)
    end
    column :gh_created_at
    column :gh_merged_at
    column :recommendation_behaviour

    actions
  end
end
