class Api::BaseController < PowerApi::BaseController
  rescue_from "Pundit::NotAuthorizedError" do |exception|
    respond_api_error(:unauthorized, message: "Unauthorized", detail: exception.message)
  end
end
