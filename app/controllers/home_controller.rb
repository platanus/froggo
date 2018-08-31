class HomeController < ApplicationController
  def index
    @user_logged_in = github_session.valid?

    @org_redirect = if @user_logged_in
                      cookies["froggo_#{github_session.name}_path"] || organizations_path
                    else
                      github_authenticate_path
                    end
  end
end
