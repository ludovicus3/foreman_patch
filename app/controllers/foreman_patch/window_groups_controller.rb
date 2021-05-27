module ForemanPatch
  class WindowGroupsController < ApplicationController

    before_action :find_resource, only: [:move, :chart, :show]

    helper ForemanPatch::PatchingHelper

    def show
      @window = @window_group.window
      @cycle = @window.cycle
      @auto_refresh = @window_group.task.try(:pending)

      respond_to do |format|
        format.json do
          group_hosts_resources
        end

        format.html
        format.js
      end
    end

    def index
      @window_groups = WindowGroup.where(window: @window)
    end

    def move
      direction = params[:direction]

      if direction == :up
      else
      end
    end

    def chart
      progress_report = @window_group.progress_report
      success = progress_report[:success]
      cancelled = progress_report[:cancelled]
      pending = progress_report[:pending]
      failed = progress_report[:failed]

      render json: {
        finished: @window_group.finished?,
        job_invocations: [
          [_('Success'),   success,   '#5CB85C'],
          [_('Failed'),    failed,    '#D9534F'],
          [_('Pending'),   pending,   '#DEDEDE'],
          [_('Cancelled'), cancelled, '#B7312D'],
        ],
        statuses: {
          success: success,
          cancelled: cancelled,
          failed: failed,
          pending: pending,
        },
      }
    end

    def resource_class
      ForemanPatch::WindowGroup
    end

    private

    def group_hosts_resources
      @resource_base = @window_group.hosts.authorized(:view_hosts, Host)

      unless params[:search].nil?
        @resource_base = @resource_base.joins(:foreman_patch_invocations)
          .where(foreman_patch_invocations: { window_group_id: @window_group.id })
      end
      @hosts = resource_base_search_and_page
      @total_hosts = resource_base_with_search.size
    end

  end
end
