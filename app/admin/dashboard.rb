ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
    columns do
      column do
        panel "Tracked repositories" do
          table_for Repository.where("tracked = true").map do
            column :full_name
            column :tracked # TO DO: convert to checkbox
            column "Edit" do |repo|
              link_to "Edit", edit_admin_repository_url(repo)
            end
            column "See open pull-requests" do # TO DO: show PR by repo
              link_to "Pull requests", nil
            end
          end
          small link_to("Manage repositories tracked here.", "repositories")
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
