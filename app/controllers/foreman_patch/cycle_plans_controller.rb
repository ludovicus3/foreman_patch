module ForemanPatch
  class CyclePlansController < ApplicationController

    helper ForemanPatch::CalendarHelper

    before_action :find_resource, only: [:edit, :update, :destroy]

    def index
      @cycle_plans = resource_base_search_and_page
    end

    def new
      @cycle_plan = CyclePlan.new
    end

    def create
      @cycle_plan = CyclePlan.new(cycle_plan_params)
    end

    def edit
    end

    def update
      if @cycle_plan.update(cycle_plan_params)
        process_success success_hash
      else
        process_error
      end
    end

    def destroy
      if @cycle_plan.destroy
        process_success success_hash
      else
        process_error
      end
    end

    def resource_class
      ForemanPatch::CyclePlan
    end

    private

    def cycle_plan_params
      params.require(:cycle_plan).permit(:name, :description, :state_date, :interval, :units, :active_count)
    end

    def success_hash
      { success_redirect: params[:redirect].presence }
    end

  end
end
