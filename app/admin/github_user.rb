ActiveAdmin.register GithubUser do
  remove_filter :gh_id, :id
  permit_params :name
  menu priority: 3
  actions :all, except: [:new, :create, :destroy]

  index do
    selectable_column
    column :login
    column :name
    column :email
    column :html_url do |o|
      link_to "Link", o.html_url
    end
    column :avatar_url do |o|
      image_tag(o.avatar_url, size: "20x20", alt: "Avatar")
    end
    column :created_at
    actions
  end

  show do |user|
    columns do
      column do
        attributes_table do
          row :avatar_url
          row :email
          row :gh_id
          row :html_url
          row :login
          row :name
          row :created_at
          row :updated_at
        end
      end

      column do
        panel "User Organizations" do
          table_for user.organization_memberships do
            column :id
            column (:name) { |membership| membership.organization.login }
            column :is_member_of_default_team
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
