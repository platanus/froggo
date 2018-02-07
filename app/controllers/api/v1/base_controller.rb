module Api
  module V1
    class BaseController < Api::BaseController
      before_action do
        self.namespace_for_serializer = Api::V1
      end
    end
  end
end
