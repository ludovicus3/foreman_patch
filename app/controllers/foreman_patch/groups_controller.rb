module ForemanPatch
  class GroupsController < ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include Foreman::Controller::CsvResponder

    before_action :find_resource, only: [:edit, :update, :destroy]
    before_action :setup_search_options, only: :index

    def index
      respond_to do |format|
        format.html do
          @groups = resource_base_search_and_page
          render :index
        end
        format.csv do
          csv_response(resource_base_with_search)
        end
      end
    end

    def new
      @group = Group.new
    end

    def create
      @group = Group.new(group_params)
      if @group.save
        process_success object: @group
      else
        process_error object: @group
      end
    end

    def edit
    end

    def update
      if @group.update(group_params)
        process_success object: @group
      else
        process_error object: @group
      end
    end

    def destroy
      if @group.destroy
        process_success object: @group
      else
        process_error object: @group
      end
    end

    def resource_class
      ForemanPatch::Group
    end

    def csv_columns
      [:name, :default_window_plan, :hosts_count]
    end

    private

    def group_params
      params.require(:group).permit(:name, :description, :default_window_plan_id, :max_unavailable, :priority)
    end

  end
end
