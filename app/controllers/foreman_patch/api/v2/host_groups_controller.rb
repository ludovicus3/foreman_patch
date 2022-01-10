module ForemanPatch
  module Api
    module V2
      class HostGroupsController < BaseController
        def_param_group :group_facet_attributes do
          param :group_id, Integer
        end
      end
    end
  end
end

