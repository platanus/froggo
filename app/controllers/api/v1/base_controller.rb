class Api::V1::BaseController < Api::BaseController
  skip_before_action :verify_authenticity_token
  before_action do
    self.namespace_for_serializer = ::Api::V1
  end
end
