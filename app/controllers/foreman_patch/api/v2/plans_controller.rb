module ForemanPatch
  module Api
    module V2
      class PlansController < ApiController

        resource_description do
          resource_id 'patch_plans'
          api_version 'v2'
          api_base_url '/foreman_patch/api'
        end

        before_action :find_plan, only: [:show, :update, :execute, :destroy]

        api :GET, '/plans', N_('List cycle plans')
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(ForemanPatch::Plan)
        def index
          @plans = resource_scope_for_index
        end

        api :GET, '/plans/:id', 'Show cycle plan details'
        param :id, :identifier, desc: 'Id of the group'
        def show
        end

        def_param_group :plan do
          param :plan, Hash, required: true, action_aware: true do
            param :name, String, desc: N_('Name of the cycle plan'), required: true
            param :description, String, desc: N_('Description of the cycle plan')
            param :start_date, String, desc: N_('Date of the first execution of cycle plan'), required: true
            param :interval, Integer, desc: N_('Number of units between cycles'), required: true
            param :units, Plan::UNITS, desc: N_('Unit of count between cycles'), required: true
            param :active_count, Integer, desc: N_('Number of cycles to have active/planned'), required: true
          end
        end

        api :POST, '/plans', 'Create a new cycle plan'
        param_group :plan, as: :create
        def create
          @plan = Plan.new(plan_params)
          @plan.save!
        end

        api :PUT, '/plans/:id', N_('Update a cycle plan')
        param :id, Integer, desc: N_('Id of cycle plan'), required: true
        param_group :plan
        def update
          @plan.update!(plan_params)
        end

        api :DELETE, '/plans/:id', N_('Destroy a cycle plan')
        param :id, Integer, desc: N_('Id of the cycle plan')
        def destroy
          @plan.destroy!
        end

        private

        def find_plan
          @plan ||= Plan.find(params[:id])
        end

        def plan_params
          params.require(:plan).permit(:name, :description, :start_date, :interval, :units, :active_count)
        end

      end
    end
  end
end

