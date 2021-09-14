module Actions
  module ForemanPatch
    module Cycle
      class Plan < Actions::ActionWithSubPlans

        def resource_locks
          :link
        end

        def delay(delay_options, plan)
          add_missing_task_group(plan)
          action_subject(plan)

          super delay_options, plan
        end

        def plan(plan)
          add_missing_task_group(plan)
          action_subject(plan)

          creation = plan_action(::Actions::ForemanPatch::Cycle::Create, params(plan))

          plan_self cycle: creation.output[:cycle]
        end

        def create_sub_plans
          cycle_plan.window_plans.map do |window_plan|
            trigger(::Actions::ForemanPatch::Window::Plan, window_plan, cycle)
          end
        end

        def on_finish
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
            name: plan.name,
            description: plan.description,
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
