module Actions
  module ForemanPatch
    module Cycle
      class Initiate < Actions::EntryAction

        def delay(delay_options, cycle)
          input.update serialize_args(cycle: cycle)

          super delay_options, cycle
        end

        def plan(cycle)
          input.update serialize_args(cycle: cycle)

          cycle.windows.each do |window|
            plan_action(Actions::ForemanPatch::Window::ResolveHosts, window)
          end
          plan_self
        end

        def run
          content_view_versions = cycle.hosts.map do |host|
            host.content_view.version(host.lifecycle_environment)
          end.uniq

          content_view_versions.each do |version|
            next unless available_content?(version)

            ::ForemanTasks.async_task(Actions::ForemanPatch::Cycle::PrepareContent, version, _('Updating content for patch cycle: %s') % cycle.name)
          end
        end

        def finalize
          cycle.windows.each(&:schedule)
        end

        def humanized_name
          _('Initiating patch cycle: %s') % cycle.name
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

        private

        def options(version, components)
          {
            content: {
              package_ids: version.available_packages,
              errata_ids: version.available_errata,
              deb_ids: ::Katello::Deb.in_repositories(version.library_repos).where.not(id: version.debs),
            },
            resolve_dependencies: true,
            description: humanized_name,
            new_components: components,
          }
        end

        def available_content?(version)
          version.available_packages.any? or 
            version.available_errata.any? or
            ::Katello::Deb.in_repositories(version.library_repos).where.not(id: version.debs).any?
        end

      end
    end
  end
end
