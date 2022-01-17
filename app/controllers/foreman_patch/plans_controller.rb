module ForemanPatch
  class PlansController < ApplicationController

    helper ForemanPatch::CalendarHelper

    before_action :find_resource, only: [:show, :edit, :update, :destroy]

    def index
      @plans = resource_base_search_and_page
    end

    def new
      @plan = Plan.new
    end

    def create
      @plan = Plan.new(plan_params)
    end

    def show
    end

    def edit
    end

    def update
      if @plan.update(plan_params)
        process_success success_hash
      else
        process_error
      end
    end

    def destroy
      if @plan.destroy
        process_success success_hash
      else
        process_error
      end
    end

    def resource_class
      ForemanPatch::Plan
    end

    private

    def plan_params
      params.require(:plan).permit(:name, :description, :cycle_name, :state_date, :interval, :units, :active_count)
    end

    def success_hash
      { success_redirect: params[:redirect].presence }
    end

  end
end
