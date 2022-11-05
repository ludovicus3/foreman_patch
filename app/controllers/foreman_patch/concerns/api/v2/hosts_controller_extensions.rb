module ForemanPatch
  module Concerns
    module Api::V2::HostsControllerExtensions
      extend ActiveSupport::Concern

      included do
        after_action :reschedule_patching, only: :update

        def reschedule_patching
          return if @host.group_facet.nil?
          return unless @host.group_facet.saved_change_to_attribute?(:group_id)

          ForemanTasks.async_task(Actions::ForemanPatch::Host::Reschedule, @host)
        end

      end
    end
  end
end
