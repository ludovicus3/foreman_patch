module ForemanPatch
  module Api
    class CyclesController < ApiController

      resource_description do
        resource_id 'patch_cycles'
        api_version 'v2'
        api_base_url '/foreman_patch/api'
      end

      before_action :find_cycle, only: [:show, :update, :destroy]

      api :GET, '/cycles', N_('List cycles')
      api :GET, '/cycle_plans/:cycle_plan_id/cycles', N_('List cycles created from cycle plan')
      param :cycle_plan_id, Integer, desc: N_('ID of the cycle plan')
      param_group :search_and_pagination, ::Api::V2::BaseController
      add_scoped_search_description_for(ForemanPatch::Cycle)
      def index
        @cycles = resource_scope_for_index
      end

      api :GET, '/cycles/:id', N_('Show cycle details')
      param :id, :identifier, desc: N_('Id of the group'), required: true
      def show
      end

      def_param_group :cycle do
        param :cycle, Hash, required: true, action_aware: true do
          param :name, String, desc: N_('Name of the patch cycle')
          param :description, String, desc: N_('Description of the patch cycle')
          param :start_date, Date, desc: N_('Start date of the patch cycle'), required: true
        end
      end

      api :POST, '/cycle_plans/:cycle_plan_id/cycle', N_('Create a new patch cycle')
      api :POST, '/cycles', N_('Create a new patch cycle')
      param :cycle_plan_id, Integer, desc: N_('Id of the cycle plan')
      param_group :cycle, as: :create
      def create
        @cycle = Cycle.new(cycle_params)
        @cycle.save!
      end

      api :PUT, '/cycles/:id', N_('Update a patch cycle')
      param_group :cycle
      def update
        @cycle.update!(cycle_params)
      end

      api :DELETE, '/cycle_plans/:id', N_('Destroy a cycle plan')
      param :id, Integer, desc: N_('Id of the cycle plan')
      def destroy
        @cycle.destroy!
      end

      private

      def allowed_nested_id
        %w(cycle_plan_id)
      end

      def find_cycle
        @cycle ||= Cycle.find(params[:id])
      end

      def cycle_params
        params[:cycle][:cycle_plan_id] = params[:cycle_plan_id] unless params[:cycle_plan_id].nil?
        params.require(:cycle).permit(:name, :description, :start_date, :cycle_plan_id)
      end
    end
  end
end

