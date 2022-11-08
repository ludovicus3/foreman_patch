module ForemanPatch
  module Api
    module V2
      class HostGroupsController < BaseController
        def_param_group :group_facet_attributes do
          param :group_id, Integer, desc: N_('Id of the default patch group')
          param :schedule, ['all', 'future-only', 'none'], desc: N_('Schedule host for patching on update, defaults to future-only')
        end
      end
    end
  end
end

