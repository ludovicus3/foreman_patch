module Actions
  module ForemanPatch
    module Cycle
      class NewPrepareContent < Actions::EntryAction
        include ::Katello::ContentViewHelper

        def humanized_name
          _('Minor Version Update')
        end

        def plan(cycle)
          input.update serialize_args(cycle: cycle)

          versions = cycle.hosts.map do |host|
            host.content_view.version(host.lifecycle_environment)
          end.uniq

          components = {}
          sequence do
            concurrence do
              components = update_components(versions)
            end
            concurrence do
              versions.each do |content_view_version|
                update = false
                new_components = versions.components.map do |component|
                  latest = components[{ content_view_id: component.content_view_id, major: component.major }]
                  if component != latest
                    update = true
                    latest
                  else
                    component
                  end
                end

                update_version(version, new_components) if update
              end
            end
          end          
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

        def description
          _('Updating content for patch cycle: %s') % cycle.name
        end

        private

        def available_content?(version)
          version.available_packages.any? or
            version.available_errata.any? or
            ::Katello::Deb.in_repositories(version.library_repos).where.not(id: version.debs).any?
        end

        def update_components(versions)
          new_components = {}
          versions.each_with_object(new_components) do |version, components|
            version.components.each do |component|
              key = { content_view_id: component.content_view_id, major: component.major }
              components[key] = latest_or_updated_minor_version(version) unless components.has_key? key
            end if version.content_view.composite?
          end
          new_components
        end

        def latest_or_updated_minor_version(version)
          version = ::Katello::ContentViewVersion.where(content_view_id: version.content_view_id, major: version.major).order(minor: :desc).first
          if available_content?(latest)
            plan_action(::Actions::Katello::ContentViewVersion::IncrementalUpdate, 
                        version,
                        version.environments,
                        description: description
                       ).new_content_view_version
          else
            version
          end
        end

        def update_version(version, components)
          plan_action(::Actions::Katello::ContentViewVersion::IncrementalUpdate,
                            version,
                            version.environments,
                            new_components: components,
                            description: description)
        end
      end
    end
  end
end


