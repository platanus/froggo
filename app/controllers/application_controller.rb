class ApplicationController < ActionController::Base
  include GithubAuthenticable

  protect_from_forgery with: :exception
end
