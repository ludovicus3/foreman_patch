module ForemanPatch
  module Api
    class CyclePlansController < ApiController

      resource_description do
        resource_id 'cycle_plans'
        api_version 'v2'
        api_base_url '/foreman_patch/api'
      end

      before_action :find_cycle_plan, only: [:show, :update, :destoy]

      def_param_group :cycle_plan do
        param :name, String, desc: N_('Name of the cycle plan'), required: true
        param :description, String, desc: N_('Description of the cycle plan')
        param :start_date, String, desc: N_('Date of the first execution of cycle plan'), required: true
        param :every, Hash, desc: N_('Repeat cycle plan parameters'), required: true do
          param :count, Integer, desc: N_('Number of units between cycles'), required: true
          param :units, CyclePlan::UNITS, desc: N_('Unit of count between cycles'), required: true
        end
        param :active_count, Integer, desc: N_('Number of cycles to have active/planned')
      end

      api :GET, '/cycle_plans', N_('List cycle plans')
      param_group :search_and_pagination, ::Api::V2::BaseController
      add_scoped_search_description_for(ForemanPatch::CyclePlan)
      def index
        @cycles = resource_scope_for_index
      end

      api :GET, '/cycle_plans/:id', 'Show cycle plan details'
      param :id, :identifier, desc: 'Id of the group'
      def show
      end

      api :POST, '/cycle_plans', 'Create a new cycle plan'
      param_group :cycle_plan
      def create
        @cycle_plan = CyclePlan.new(cycle_plan_params)
        @cycle.save!
      end

      api :PUT, '/cycle_plans/:id', N_('Update a cycle plan')
      param :id, Integer, desc: N_('Id of cycle plan')
      param_group :cycle_plan
      def update
        @cycle_plan.update!(cycle_plan_params)
      end

      api :DELETE, '/cycle_plans/:id', N_('Destroy a cycle plan')
      param :id, Integer, desc: N_('Id of the cycle plan')
      def destroy
        @cycle_plan.destroy!
      end

      private

      def find_cycle_plan
        CyclePlan.find(params[:id])
      end

      def cycle_plan_params
        params[:cycle_plan][:interval] = params[:cycle_plan][:every][:count]
        params[:cycle_plan][:units] = params[:cycle_plan][:every][:count]
        params.require(:cycle_plan).permit(:name, :description, :interval, :units, :start_date, :active_count)
      end
    end
  end
end

