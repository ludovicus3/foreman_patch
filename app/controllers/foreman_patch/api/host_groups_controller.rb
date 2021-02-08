module ForemanPatch
  module Api
    class HostGroupsController < ApiController
      def_param_group :group_facet_attributes do
        param :group_id, Integer
      end
    end
  end
end

