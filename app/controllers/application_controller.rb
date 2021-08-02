class ApplicationController < ActionController::Base
  include GithubAuthenticable
  include Pundit

  protect_from_forgery with: :exception
end
