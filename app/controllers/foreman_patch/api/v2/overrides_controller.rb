module ForemanPatch
  module Api
    module V2
      class OverridesController < ApiController

        resource_description do
          resource_id 'patch_overrides'
          api_version 'v2'
          api_base_url '/foreman_patch/api'
        end

        before_action :find_resource, only: [:show, :destroy]

        api :GET, '/overrides', N_('List overrides')
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(ForemanPatch::Override)
        def index
          @overrides = resource_scope_for_index
        end

        api :GET, '/overrides/:id', N_('Show override details')
        param :id, Integer, desc: N_('Id of the override'), required: true
        def show
        end

        api :POST, '/overrides', N_('Create a new Override')
        param :override, Hash, required: true, action_aware: true do
          param :source_id, Integer, desc: N_('Id of the original Invocation'), required: true
          param :round_id, Integer, desc: N_('Id of the target round')
          param :reason, String, desc: N_('Reason for the override')
        end
        def create
          @override = Override.create!(override_params)

          if params[:override][:round_id]
            @override.target.create!(host_id: @override.source.host_id, round_id: params[:override][:round_id])
          end
        end

        api :DELETE, '/overrides/:id', N_('Destroy an override')
        param :id, Integer, desc: N_('Id of the override')
        def destroy
          @override.destroy!
        end

        def resource_class
          ForemanPatch::Override
        end

        private

        def override_params
          params[:override][:user_id] = User.current.id
          params.require(:override).permit(:source_id, :user_id, :reason)
        end

      end
    end
  end
end
