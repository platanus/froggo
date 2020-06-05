module Api::ErrorConcern
  extend ActiveSupport::Concern

  included do
    rescue_from "Exception" do |exception|
      logger.error exception.message
      logger.error exception.backtrace.join("\n")
      Raven.capture_exception(exception)
      respond_api_error(:internal_server_error, message: "server_error",
                                                type: exception.class.to_s,
                                                detail: exception.message)
    end

    rescue_from "ActionController::UnknownFormat" do |exception|
      respond_api_error(:not_found, message: "unknown_format",
                                    detail: exception.class.to_s)
    end

    rescue_from "ActiveRecord::RecordNotFound" do |exception|
      respond_api_error(:not_found, message: "record_not_found",
                                    detail: exception.message)
    end

    rescue_from "ActiveModel::ForbiddenAttributesError" do |exception|
      respond_api_error(:bad_request, message: "protected_attributes",
                                      detail: exception.message)
    end

    rescue_from "ActiveRecord::RecordInvalid" do |exception|
      respond_api_error(:bad_request, message: "invalid_attributes",
                                      errors: exception.record.errors)
    end

    rescue_from "ApiVersionError" do
      data = ["application/json; version=1", "application/json; version=2"]
      respond_api_error(:not_acceptable, message: "invalid_api_version",
                                         detail: data)
    end
  end

  def respond_api_error(status, error = {})
    render json: error, status: status
  end
end
