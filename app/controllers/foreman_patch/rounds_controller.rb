module ForemanPatch
  class RoundsController < ApplicationController

    before_action :find_resource, only: [:move, :chart, :show]

    helper ForemanPatch::PatchingHelper

    def show
      @window = @round.window
      @cycle = @window.cycle
      @auto_refresh = @round.task.try(:pending)

      respond_to do |format|
        format.json do
          group_hosts_resources
        end

        format.html
        format.js
      end
    end

    def index
      @rounds = Round.where(window: @window)
    end

    def chart
      progress_report = @round.progress_report
      success = progress_report[:success]
      cancelled = progress_report[:cancelled]
      pending = progress_report[:pending]
      failed = progress_report[:failed]

      render json: {
        finished: @round.finished?,
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

    def update
    end

    def resource_class
      ForemanPatch::Round
    end

    private

    def group_hosts_resources
      @resource_base = @round.hosts.authorized(:view_hosts, Host)

      unless params[:search].nil?
        @resource_base = @resource_base.joins(:foreman_patch_invocations)
          .where(foreman_patch_invocations: { round_id: @round.id })
      end
      @hosts = resource_base_search_and_page
      @total_hosts = resource_base_with_search.size
    end

  end
end
