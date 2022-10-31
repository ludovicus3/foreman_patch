module Actions
  module ForemanPatch
    module Window
      class Create < Actions::EntryAction

        def resource_locks
          :link
        end

        def plan(window_plan, cycle)
          action_subject(window_plan, cycle)

          window = cycle.windows.create!(window_plan.to_params)

          sequence do
            concurrence do
              window_plan.groups.each do |group|
                plan_action(Actions::ForemanPatch::Round::Create, group, window)
              end
            end

            plan_action(Actions::ForemanPatch::Window::Publish, window)
          end

          plan_self(window: window.to_action_input)
        end

        def run
          output.update(window: window.to_action_input)
        end

        def window
          @window = ::ForemanPatch::Window.find(input[:window][:id])
        end

        private

      end
    end
  end
end
