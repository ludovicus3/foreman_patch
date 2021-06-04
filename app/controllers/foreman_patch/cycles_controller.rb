module ForemanPatch
  class CyclesController < ApplicationController
    include Foreman::Controller::AutoCompleteSearch

    helper ForemanPatch::CalendarHelper

    before_action :find_resource, only: [:show, :destroy]

    def index
      params[:order] ||= 'start_date DESC'
      @cycles = resource_base_search_and_page
    end

    def show
    end

    def destroy
      if @cycle.destroy
        process_success object: @cycle
      else
        process_error object: @cycle
      end
    end

    def resource_class
      ForemanPatch::Cycle
    end

    private

    def cycle_params
      params.require(:cycle).permit(:name, :description, :start_date)
    end

  end
end
