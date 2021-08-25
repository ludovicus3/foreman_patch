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

          concurrence do
            content_view_versions.each do |version|
              next unless available_content?(version)

              if version.content_view.composite?
                sequence do
                  components = []
                  concurrence do
                    version.components.reduce(components) do |list, component|
                      if available_content?(component)
                        action = plan_action(::Actions::Katello::ContentViewVersion::IncrementalUpdate,
                                             component, component.environments, options(component, []))
                        list << action.new_content_view_version
                      end
                      list
                    end
                  end
                  plan_action(::Actions::Katello::ContentViewVersion::IncrementalUpdate,
                              version, version.environments, options(version, components))
                end
              else
                plan_action(::Actions::Katello::ContentViewVersion::IncrementalUpdate,
                            version, version.environments, options(version, []))
              end
            end
          end

          plan_self
        end

        def humanized_name
          _('Update content for patching cycle: %s') % cycle.name
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

        def content_view_versions
          return @content_view_versions if defined? @content_view_versions

          @content_view_versions = cycle.hosts.map do |host|
            host.content_view.version(host.lifecycle_environment)
          end.uniq

          @content_view_versions
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
