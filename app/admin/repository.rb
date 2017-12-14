ActiveAdmin.register Repository do
  remove_filter :gh_id, :id
  permit_params :name, :tracked
  menu priority: 1
  actions :all

  index do
    selectable_column
    column :name
    column :full_name
    toggle_bool_column :tracked
    column :html_url
    column :pull_requests do |repo|
      link_to t('active_admin.pull_requests', count: repo.pull_requests.count),
              admin_repository_pull_requests_path(repo)
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :tracked
    end
    f.actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
