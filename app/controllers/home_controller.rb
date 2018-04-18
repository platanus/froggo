class HomeController < ApplicationController
  def index
    @user_logged_in = github_session.valid?
  end
end
