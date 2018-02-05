class Api::BaseController < ApplicationController
  include Api::Error
  include Api::Versioned

  self.responder = ApiResponder

  skip_before_action :verify_authenticity_token
  respond_to :json
end
