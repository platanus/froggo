class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  p "Test Pull Request"
end
