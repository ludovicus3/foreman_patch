module ForemanPatch
  module Concerns
    module HostsControllerExtensions

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

        success _('Updated hosts: changed patch group')
        redirect_to hosts_path
      end

      private

      def action_permission
        case params[:action]
        when 'select_multiple_patch_group', 'update_multiple_patch_group'
          :edit
        else
          super
        end
      end

    end
  end
end
