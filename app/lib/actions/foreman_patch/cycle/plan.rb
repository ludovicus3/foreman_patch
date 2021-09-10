module Actions
  module ForemanPatch
    module Cycle
      class Plan < Actions::EntryAction

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
          concurrence do
            plan.window_plans.each do |window_plan|
              plan_action(::Actions::ForemanPatch::Window::Plan, window_plan, creation.output[:cycle])
            end
          end
          plan_self
        end

        def run
          plan.start_date = plan.next_cycle_start
          plan.save!
        end

        def finalize
          plan.iterate
        end

        def humanized_name
          _('Plan cycle: %s') % plan.name
        end

        private

        def plan
          @plan ||= ::ForemanPatch::CyclePlan.find(input[:plan][:id])
        end

        def params(plan)
          {
            plan: plan.to_action_input,
            name: plan.name,
            description: plan.description,
            start_date: plan.start_date,
            end_date: plan.next_cycle_start - 1.day,
          }
        end

        def add_missing_task_group(plan)
          if plan.task_group.nil?
            plan.task_group = ::ForemanPatch::CyclePlanTaskGroup.create!
            plan.save!
          end
          task.add_missing_task_groups(plan.task_group)
        end

      end
    end
  end
end
