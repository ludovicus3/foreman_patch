module ForemanPatch
  class WindowPlansController < ApplicationController

    before_action :find_resource, only: [:edit, :update, :destroy]
    before_action :find_plan, only: [:new, :create]

    def new
      @window_plan = WindowPlan.new
    end

    def create
      @window_plan = WindowPlan.new(window_plan_params)
    end

    def edit
    end

    def update
      if @window_plan.update(window_plan_params)
        process_success success_hash
      else
        process_error
      end
    end

    def destroy
      if @window_plan.destroy
        process_success success_hash
      else
        process_error
      end
    end

    def resource_class
      ForemanPatch::WindowPlan
    end

    private

    def allowed_nested_id
      %w(plan_id)
    end

    def find_plan
      @plan ||= ForemanPatch::Plan.find(params[:plan_id])
    end

    def window_plan_params
      params[:window_plan][:plan_id] = params[:plan_id] unless params[:plan_id].nil?
      params.require(:window_plan).permit(:name, :description, :state_day, :start_time, :plan_id)
    end

    def success_hash
      { success_redirect: params[:redirect].presence }
    end

  end
end
