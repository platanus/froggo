class HomeController < ApplicationController
  before_action :redirect_if_already_logged_in

  def index
    @request_login_url = github_authenticate_path
  end

  private

  def redirect_if_already_logged_in
    redirect_to user_path(github_user) if github_session.valid?
  end
end
