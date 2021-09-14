module Actions
  module ForemanPatch
    module Window
      class Plan < Actions::EntryAction

        def resource_locks
          :link
        end

        def plan(window_plan, cycle)
          action_subject(window_plan, cycle)

          sequence do
            action = plan_action(::Actions::ForemanPatch::Window::Create, params(window_plan, cycle))

            concurrence do
              window_plan.groups.each do |group|
                plan_action(::Actions::ForemanPatch::Round::Plan, group, action.output[:window])
              end
            end

            plan_action(::Actions::ForemanPatch::Window::Publish, action.output[:window])
          end
        end

        def humanized_name
          _('Plan window: %s') % input[:window_plan][:name]
        end

        private

        def params(window_plan, cycle)
          {
            cycle: cycle.to_action_input,
            name: window_plan.name,
            description: window_plan.description,
            start_at: window_plan.start_at(cycle).to_s,
            end_by: window_plan.end_by(cycle).to_s,
          }
        end

      end
    end
  end
end


