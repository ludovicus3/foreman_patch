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
          @invocations = resource_scope_for_index
        end

        api :GET, '/invocations/:id', N_('Get details of an invocation')
        param :id, :identifier, required: true
        def show
        end

        api :PUT, '/invocations/:id', N_('Move the invocation to another round')
        param :id, :identifier, required: true
        param :invocation, Hash, required: true do
          param :round_id, Integer, required: true
        end
        def update
          process_response @invocation.update(invocation_params)
        end

        api :PUT, '/invocations/move', N_('Move invocations to another round')
        param :ids, Array, required: true, desc: N_('List of invocation ids')
        param :round_id, Integer, required: true, desc: N_('Id of the destination round')
        def move
          @invocations = ForemanPatch::Invocation.where(id: params[:ids])

          @errors = []
          @invocations.each do |invocation|
            round = invocation.round.cycle.rounds.find(params[:round_id])
            invocation.update(round: round)
          rescue
          end

          @invocations = ForemanPatch::Invocation.where(id: params[:ids], round_id: params[:round_id])
        end

        api :PUT, '/invocations/cancel', N_('Cancel invocations')
        param :ids, Array, required: true, desc: N_('List of invocation ids')
        def cancel
          @invocations = ForemanPatch::Invocation.where(id: params[:ids])
          @invocations.update_all(status: 'cancelled')          
        end

        api :DELETE, 'invocations/:id', N_('Delete the patch invocation')
        param :id, :identifier, required: true
        def destroy
          process_response @invocation.destroy
        end

        def resource_class
          ForemanPatch::Invocation
        end

        def resource_scope(options = {})
          if action_name == 'index'
            @round.invocations.includes(:host).where(host: ::Host.authorized(:view_hosts, ::Host))
          else
            super(options)
          end
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

