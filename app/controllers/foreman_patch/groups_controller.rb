module ForemanPatch
  class GroupsController < ApplicationController

    before_action :find_group, only: [:edit, :update, :destroy]

    def index
      @groups = resource_base_search_and_page
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

    def controller_name
      'foreman_patch_groups'
    end

    def resource_class
      ForemanPatch::Group
    end

    private

    def find_group
      @group ||= Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :description, :default_window_plan_id, :max_unavailable, :default_priority)
    end

  end
end
