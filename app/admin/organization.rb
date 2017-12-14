ActiveAdmin.register Organization do
  remove_filter :gh_id, :id
  permit_params :name, :tracked
  menu priority: 1
  actions :all, except: [:create, :destroy]

  index do
    selectable_column
    column :login
    column :name
    column :description
    toggle_bool_column :tracked
    column :html_url do |o|
      link_to "Link", o.html_url
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
end
