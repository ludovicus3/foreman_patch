module Actions
  module ForemanPatch
    module Cycle
      class PrepareContent < Actions::EntryAction

        def resource_locks
          :link
        end

        def delay(delay_options, cycle)
          action_subject(cycle)

          super delay_options, cycle
        end

        def plan(cycle)
          action_subject(cycle)

          versions = cycle.hosts.map do |host|
            host.content_view.version(host.lifecycle_environment)
          end

          versions.each do |version|
            append_missing_content(version)

            append_version_environment(version)
          end

          plan_action(::Actions::Katello::ContentView::IncrementalUpdates,
                      version_environments, composite_version_environments,
                      content, true, [], humanized_name)

          plan_self
        end

        def humanized_name
          _('Update content for patching cycle: %s') % cycle.name
        end

        private

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

        def append_version_environment(version)
          return unless version.available_packages.any? or version.available_errata.any?

          version_environment = {
            content_view_version: version,
            environments: version.environments,
          }

          if version.content_view.composite?
            composite_version_environments << version_environment

            version.components.each do |component|
              append_version_environment(component)
            end
          else
            version_environments << version_environment
          end
        end
        
        def version_environments
          @version_environments ||= []
        end

        def composite_version_environments
          @composite_version_environments ||= []
        end

        def content
          @content ||= { 
            package_ids: [],
            errata_ids: [],
          }
        end

        def append_missing_content(version)
          content[:package_ids].concat version.available_packages
          content[:errata_ids].concat version.available_errata
        end

      end
    end
  end
end
