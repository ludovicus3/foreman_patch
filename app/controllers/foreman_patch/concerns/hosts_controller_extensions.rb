module ForemanPatch
  module Concerns
    module HostsControllerExtensions
      extend ActiveSupport::Concern

      module Overrides
        def action_permission
          case params[:action]
          when 'select_multiple_patch_group', 'update_multiple_patch_group'
            :edit
          else
            super
          end
        end
      end

      included do
        prepend Overrides

        after_action :reschedule_patching, only: :update

        def select_multiple_patch_group
          find_multiple
        end

        def update_multiple_patch_group
          find_multiple

          if (params['patch_group']['id'].blank?)
            @hosts.each do |host|
              group_facet = host.group_facet
              group_facet.group = nil unless group_facet.blank?
              host.save!
            end
          else
            patch_group = ForemanPatch::Group.find(params['patch_group']['id'])

            @hosts.each do |host|
              group_facet = host.group_facet || host.build_group_facet
              group_facet.group = patch_group
              host.save!
            end
          end

          ForemanTasks.async_task(Actions::ForemanPatch::Host::Reschedule, @hosts, include_active: params['patch_group']['include_active'])

          success _('Updated hosts: changed patch group')
          redirect_back_or_to hosts_path
        end

        def reschedule_patching
          return if @host.group_facet.nil?
          return unless @host.group_facet.saved_change_to_attribute?(:group_id)

          ForemanTasks.async_task(Actions::ForemanPatch::Host::Reschedule, @host)
        end

      end
    end
  end
end
