module Actions
  module ForemanPatch
    module Cycle
      class Plan < Actions::EntryAction

        def delay(delay_options, plan)
          input.update serialize_args(plan: plan)
          add_missing_task_group(plan)

          super delay_options, plan
        end

        def plan(plan)
          input.update serialize_args(plan: plan)
          add_missing_task_group(plan)

          sequence do
            creation = plan_action(::Actions::ForemanPatch::Cycle::Create, params(plan))

            concurrence do
              plan.window_plans.each do |window_plan|
                plan_action(::Actions::ForemanPatch::Window::Plan, window_plan, creation.output[:cycle])
              end
            end

            plan_self
          end
        end

        def run
          cycle_plan.start_date = cycle_plan.next_cycle_start
          cycle_plan.save!
        end

        def finalize
          cycle_plan.iterate
        end

        def humanized_name
          _('Plan cycle: %s') % input[:plan][:name]
        end

        private

        def cycle_plan
          @cycle_plan ||= ::ForemanPatch::Plan.find(input[:plan][:id])
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

        def params(plan)
          {
            plan_id: plan.id,
            name: ::ForemanPatch::CycleNameGenerator.generate(plan),
            start_date: plan.start_date.to_s,
            end_date: (plan.next_cycle_start - 1.day).to_s,
          }
        end

        def add_missing_task_group(plan)
          if plan.task_group.nil?
            plan.task_group = ::ForemanPatch::PlanTaskGroup.create!
            plan.save!
          end
          task.add_missing_task_groups(plan.task_group)
        end

      end
    end
  end
end
