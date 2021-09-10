module Actions
  module ForemanPatch
    module CyclePlan
      class Iterate < Actions::EntryAction

        def resource_locks
          :link
        end

        def delay(delay_options, cycle_plan)
          add_missing_task_group(cycle_plan)
          action_subject(cycle_plan)

          super delay_options, cycle_plan
        end

        def plan(cycle_plan)
          add_missing_task_group(cycle_plan)
          action_subject(cycle_plan)

          plan_action(::Actions::ForemanPatch::Cycle::Create, cycle_plan)
          plan_self
        end

        def run
          cycle_plan.start_date = cycle_plan.next_cycle_start
          cycle_plan.save!
        end

        def finalize
          cycle_plan.schedule_iterations
        end

        def humanized_name
          _('Iterate cycle plan: %s') % cycle_plan.name
        end

        private

        def cycle_plan
          @cycle_plan ||= ::ForemanPatch::CyclePlan.find(input[:cycle_plan][:id])
        end

        def add_missing_task_group(cycle_plan)
          if cycle_plan.task_group.nil?
            cycle_plan.task_group = ::ForemanPatch::CyclePlanTaskGroup.create!
            cycle_plan.save!
          end
          task.add_missing_task_groups(cycle_plan.task_group)
        end

      end
    end
  end
end
