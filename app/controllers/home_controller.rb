class HomeController < ApplicationController
  def index
    @user_logged_in = github_session.valid?
    @request_login_url = if @user_logged_in
                           user_path github_user
                         else
                           github_authenticate_path
                         end
  end
end
