module ForemanPatch
  module Api
    module V2
      class BaseController < ::Api::V2::BaseController
        resource_description do
          api_version '2'
          api_base_url '/foreman_patch/api'
        end
      end
    end
  end
end
