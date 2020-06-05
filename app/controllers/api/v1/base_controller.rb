class Api::V1::BaseController < ApplicationController
  include Api::ErrorConcern
  include Api::Versioned

  self.responder = ApiResponder

  skip_before_action :verify_authenticity_token
  respond_to :json
end
