module ForemanPatch
  module Api
    module V2
      class RoundsController < BaseController

        resource_description do
          resource_id 'patch_rounds'
          api_version 'v2'
          api_base_url '/foreman_patch/api'
        end

        before_action :find_resource, only: [:update, :show, :update, :destroy]

        api :GET, '/rounds', N_('List rounds')
        api :GET, '/windows/:window_id/rounds'. N_('List window groups within a given window')
        param :window_id, :identifier
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(Round)
        def index
          @rounds = resource_scope_for_index(params.permit(:window_id))
        end

        api :GET, '/rounds/:id', 'Show round details'
        param :id, :identifier, desc: 'Id of the round', required: true
        def show
        end

        def_param_group :round do
          param :round, Hash, required: true, action_aware: true do
            param :name, String, desc: N_('Name of the patch round'), required: true
            param :description, String, desc: N_('Description of the patch round')
            param :window_id, Integer, desc: N_('ID of the window'), required: true
            param :group_id, Integer, desc: N_('ID of the Group')
            param :max_unavailable, Integer, desc: N_('Maximum number of hosts that can be patched at a time')
            param :priority, Integer, desc: N_('Default priority of round within its window (Lowest goes first)')
          end
        end

        api :POST, '/rounds', N_('Create a new patch round')
        param_group :round, as: :create
        def create
          @round = Round.new(round_params)
          process_response @round.save
        end

        api :PUT, '/rounds/:id', N_('Update a patch round')
        param :id, Integer, desc: N_('ID of the round'), required: true
        param_group :round
        def update
          process_response @round.update(round_params)
        end

        api :DELETE, '/rounds/:id', N_('Destroy a patch round')
        param :id, Integer, desc: N_('ID of the round'), required: true
        def destroy
          process_response @round.destroy
        end

        def resource_class
          ForemanPatch::Round
        end

        private

        def round_params
          params.require(:round).permit(:name, :description, :window_id, :group_id, :max_unavailable, :priority)
        end
      end
    end
  end
end

