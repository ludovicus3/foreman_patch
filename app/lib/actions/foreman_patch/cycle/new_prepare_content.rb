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

          sequence do
            concurrence do
              update_content_components
            end
            concurrence do
              update_content_compositions
            end
          end
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

        def contents
          @contents ||= ::ForemanPatch::CycleContent.new(cycle)
        end

        def description
          _('Updating content for patch cycle: %s') % cycle.name
        end

        private

        def update_content_components
          contents.each do |content|
            next unless (not content.composite?) and content.update?

            plan_action(Actions::Katello::ContentViewVersion::IncrementalUpdate,
              content.version,
              content.environments,
              new_components: content.components,
              description: description)
          end
        end

        def update_content_compositions
          contents.each do |content|
            next unless content.composite? and content.update?

            plan_action(Actions::Katello::ContentViewVersion::IncrementalUpdate,
              content.version,
              content.environments,
              new_components: content.components,
              description: description)
          end
        end
      end
    end
  end
end


