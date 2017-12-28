ActiveAdmin.register GithubUser do
  remove_filter :gh_id, :id
  permit_params :name, :tracked
  menu priority: 3
  actions :all, except: [:new, :create, :destroy]

  index do
    selectable_column
    column :login
    column :name
    column :email
    toggle_bool_column :tracked
    column :html_url do |o|
      link_to "Link", o.html_url
    end
    column :avatar_url do |o|
      image_tag(o.avatar_url, size: "20x20", alt: "Avatar")
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
