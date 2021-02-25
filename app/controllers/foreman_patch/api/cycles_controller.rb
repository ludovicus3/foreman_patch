module ForemanPatch
  module Api
    class CyclesController < ApiController

      resource_description do
        resource_id 'cycles'
        api_version 'v2'
        api_base_url '/foreman_patch/api'
      end

      before_action :find_cycle, only: [:show, :destroy]

      api :GET, '/cycles', N_('List cycles')
      api :GET, '/cycle_plans/:cycle_plan_id/cycles', N_('List cycles created from cycle plan')
      param :cycle_plan_id, Integer, desc: N_('ID of the cycle plan')
      param_group :search_and_pagination, ::Api::V2::BaseController
      add_scoped_search_description_for(ForemanPatch::Cycle)
      def index
        @cycles = resource_scope_for_index
      end

      api :GET, '/cycles/:id', 'Show cycle details'
      param :id, :identifier, desc: 'Id of the group'
      def show
      end

      api :POST, '/cycle_plans/:cycle_plan_id/cycle', N_('Create a new patch cycle')
      param :cycle_plan_id, Integer, desc: N_('Id of the cycle plan')
      param :start_date, Date, desc: N_('Date to start the patch cycle')
      def create
        @cycle = Cycle.new(cycle_plan_id: params[:cycle_plan_id], start_date: params[:start_date])
        @cycle.save!
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

      def find_cycle_plan
        @cycle ||= Cycle.find(params[:id])
      end
    end
  end
end

