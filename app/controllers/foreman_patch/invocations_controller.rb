module ForemanPatch
  class InvocationsController < ApplicationController

    helper ForemanPatch::PatchingHelper

    def show
      @invocation = ForemanPatch::Invocation.find(params[:id])
      @host = @invocation.host

      @group = @invocation.window_group
      @window = @group.window
      @cycle = @window.cycle

      @auto_refresh = @invocation.task.pending?
      @since = params[:since].to_f if params[:since].present?

      @invocation.phases.each do |phase|
        @line_sets = phase.live_output
        @line_sets = @line_sets.drop_while { |o| o['timestamp'].to_f <= @since } if @since

        unless @line_sets.empty?
          @phase = phase.label.demodulize.underscore
          break
        end
      end

      @line_counter = params[:line_counter].to_i
    end

  end
end
