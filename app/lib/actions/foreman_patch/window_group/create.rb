module Actions
  module ForemanPatch
    module WindowGroup
      class Create < Actions::EntryAction

        def plan(window, group)
          action_subject(group, window: window)

          plan_self(params: params)
        end

        def run
          window_group = window.window_groups.create!(params)

          output[:window_group] = window_group.to_action_input
        end

        def window_group
          @window_group ||= ::ForemanPatch::WindowGroup.find(output[:window_group][:id])
        end

        private

        def params
          @params ||= {
            name: group.name,
            description: group.description,
            priority: group.priority,
            max_unavailable: group.max_unavailable,
          }
        end

        def group
          @group ||= ::ForemanPatch::Group.find(input[:group][:id])
        end

        def window
          @window ||= ::ForemanPatch::Window.find(input[:window][:id])
        end

      end
    end
  end
end

