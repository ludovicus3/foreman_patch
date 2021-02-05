module ForemanPatch
  module Api
    class ApiController < ::Api::V2::BaseController

      resource_description do
        api_version 'v2'
        api_base_url '/foreman_patch/api'
      end

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

