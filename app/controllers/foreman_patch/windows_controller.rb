module ForemanPatch
  class WindowsController < ApplicationController

    before_action :find_cycle, only: [:new, :create]
    before_action :find_resource, only: [:show, :destroy]

    def new
      @window = Window.new
    end

    def create
      @window = Window.new(window_params)
      if @window.save
        process_success object: @window
      else
        process_error object: @window
      end
    end

    def show
    end

    def destroy
      if @window.destroy
        process_success object: @window
      else
        process_error object: @window
      end
    end

    def resource_class
      ForemanPatch::Window
    end

    private

    def find_cycle
      @cycle ||= Cycle.find(params[:cycle_id])
    end

    def window_params
      params[:window][:cycle_id] = @cycle.id unless @cycle.nil?
      params.require(:window).permit(:name, :description, :start_at, :end_by)
    end

  end
end
