module ForemanPatch
  module Api
    module V2
      class InvocationsController < ApiController

        resource_description do
          resource_id 'patch_invocations'
          api_version 'v2'
          api_base_url '/foreman_patch/api'
        end

        before_action :find_window_group, only: [:index]

        api :GET, '/window_groups/:window_group_id/invocations',
          N_('List patch invocations for a patch group')
        param :window_group_id, :identifier, required: true
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(ForemanPatch::Invocation)
        def index
          @invocations = @window_group.invocations
            .includes(:host)
            .where(host: ::Host.authorized(:view_hosts, ::Host))
            .search_for(*search_options)
            .paginate(paginate_options)
        end

        def resource_class
          ForemanPatch::Invocation
        end

        private

        def find_window_group
          @window_group = ForemanPatch::WindowGroup.find(params[:window_group_id])
        end

      end
    end
  end
end

