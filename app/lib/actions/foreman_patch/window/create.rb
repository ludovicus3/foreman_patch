module Actions
  module ForemanPatch
    module Window
      class Create < Actions::EntryAction

        def plan(window_plan, cycle)
          action_subject(window_plan, cycle: cycle)

          sequence do
            plan_self

            concurrence do
              window_plan.groups.each do |group|
                a = plan_action(::Actions::ForemanPatch::WindowGroup::Create, output[:window], group)
                plan_action(::Actions::ForemanPatch::WindowGroup::ResolveHosts, a.output[:window_group], group)
              end
            end

            plan_action(::Actions::ForemanPatch::Window::Publish, output[:window])
          end
        end

        def run
          window = cycle.windows.create!(params)

          output[:window] = window.to_action_input
        end

        def window
          @window ||= ::ForemanPatch::Window.find(output[:window][:id])
        end

        private

        def params
          @params ||= {
            name: window_plan.name,
            description: window_plan.description,
            start_at: window_plan.start_at(cycle),
            end_by: window_plan.end_by(cycle),
          }
        end

        def window_plan
          @window_plan ||= ::ForemanPatch::WindowPlan.find(input[:window_plan][:id])
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

      end
    end
  end
end
