module ForemanPatch
  module Api
    class ApiController < ::Api::V2::BaseController
      def resource_class
        @resource_class ||= resource_name.classify.constantize
      rescue NameError
        @resource_class ||= "ForemanPatch::#{resource_name.classify}".constantize
      end

      def resource_scope(_options = {})
        resource_class
      end
      
    end
  end
end

