module ForemanPatch
  module Concerns
    module Api::V2::HostsControllerExtensions
      extend ActiveSupport::Concern

      included do
        after_action :reschedule_patching, only: :update

        def reschedule_patching
          return if @host.group_facet.nil?
          return unless @host.group_facet.saved_change_to_attribute?(:group_id)

          schedule = params.dig('host', 'group_facet_attributes', 'schedule') || 'future-only'

          ForemanTasks.async_task(Actions::ForemanPatch::Host::Reschedule, @host, include_active: schedule == 'all') unless schedule == 'none'
        end

      end
    end
  end
end
