module ForemanPatch
  module Api
    module V2
      class InvocationsController < BaseController
        
        resource_description do
          resource_id 'patch_invocations'
          api_version 'v2'
          api_base_url '/foreman_patch/api'
        end

        before_action :find_round, only: [:index]
        before_action :find_resource, only: [:show, :update, :delete]

        api :GET, '/rounds/:round_id/invocations', N_('List patch invocations for a patch group')
        param :round_id, :identifier, required: true
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(Invocation)
        def index
          @invocations = @round.invocations
            .includes(:host)
            .where(host: ::Host.authorized(:view_hosts, ::Host))
            .search_for(*search_options)
            .paginate(paginate_options)
        end

        api :GET, '/invocations/:id', N_('Get details of an invocation')
        param :id, :identifier, required: true
        def show
          @invocation = ForemanPatch::Invocation.find(params[:id])
        end

        api :PUT, '/invocations/:id', N_('Move the invocation to another round')
        param :id, :identifier, required: true
        param :invocation, Hash, required: true do
          param :round_id, Integer, required: true
        end
        def update
          process_response @invocation.update(invocation_params)
        end

        api :DELETE, 'invocations/:id', N_('Delete the patch invocation')
        param :id, :identifier, required: true
        def destroy
          process_response @invocation.destroy
        end

        def resource_class
          ForemanPatch::Invocation
        end

        private

        def find_round
          @round ||= ForemanPatch::Round.find(params[:round_id])
        end

        def invocation_params
          params.require(:invocation).permit(:round_id)
        end

      end
    end
  end
end

