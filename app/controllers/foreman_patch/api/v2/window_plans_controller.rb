module ForemanPatch
  module Api
    module V2
      class WindowPlansController < ApiController

        resource_description do
          resource_id 'patch_window_plans'
          api_version 'v2'
          api_base_url '/foreman_patch/api'
        end

        before_action :find_window_plan, only: [:show, :update, :destoy]

        api :GET, '/window_plans', N_('List window plans')
        api :GET, '/plans/:plan_id/window_plans', N_('List window plans per cycle plan')
        param :plan_id, Integer, desc: N_('ID of the cycle plan')
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(ForemanPatch::WindowPlan)
        def index
          @window_plans = resource_scope_for_index
        end

        api :GET, '/window_plans/:id', 'Show window plan details'
        param :id, :identifier, desc: 'Id of the group'
        def show
        end

        def_param_group :window_plan do
          param :window_plan, Hash, required: true, action_aware: true do
            param :name, String, desc: N_('Name of the window plan'), required: true
            param :description, String, desc: N_('Description of the window plan')
            param :start_day, Integer, desc: N_('Day of execution of the window plan relative to cycle start'), required: true
            param :start_time, String, desc: N_('Number of windows to have active/planned'), required: true
            param :duration, Integer, desc: N_('Duration of the patch window in seconds'), required: true
          end
        end

        api :POST, '/plans/:plan_id/window_plans', 'Create a new window plan'
        param :plan_id, Integer, desc: N_('Id of plan')
        param_group :window_plan, as: :create
        def create
          @window_plan = WindowPlan.new(window_plan_params)
          @window_plan.save!
        end

        api :PUT, '/window_plans/:id', N_('Update a window plan')
        param :id, Integer, desc: N_('Id of window plan')
        param_group :window_plan
        def update
          @window_plan.update!(window_plan_params)
        end

        api :DELETE, '/window_plans/:id', N_('Destroy a window plan')
        param :id, Integer, desc: N_('Id of the window plan')
        def destroy
          @window_plan.destroy!
        end

        private

        def allowed_nested_id
          %w(plan_id)
        end

        def find_window_plan
          @window_plan ||= WindowPlan.find(params[:id])
        end

        def window_plan_params
          params[:window_plan][:plan_id] = params[:plan_id] unless params[:plan_id].nil?
          params.require(:window_plan).permit(:name, :description, :start_day, :start_time, :duration, :plan_id)
        end

      end
    end
  end
end

