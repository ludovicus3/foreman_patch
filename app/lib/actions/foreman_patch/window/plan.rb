module Actions
  module ForemanPatch
    module Window
      class Plan < Actions::EntryAction

        def plan(window_plan, cycle)
          input.update serialize_args(window_plan: window_plan, cycle: cycle)

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
            cycle: cycle,
            name: window_plan.name,
            description: window_plan.description,
            start_at: window_plan.start_at.to_s,
            end_by: window_plan.end_by.to_s,
          }
        end

      end
    end
  end
end


