module Actions
  module ForemanPatch
    module CyclePlan
      class CreateCycle < Actions::ActionWithSubPlans
        include Dynflow::Action::WithSubPlans

        execution_plan_hooks.use :schedule_next_cycle, on: [:planned, :failure]

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

          plan_self
        end

        def create_sub_plans
          cycle.windows.map do |window|
            trigger(Actions::ForemanPatch::Window::Publish, window)
          end
        end

        def initiate
          cycle = ::ForemanPatch::Cycle.create!(cycle_plan: cycle_plan, start_date: Date.current)

          output[:cycle] = {
            id: cycle.id,
            name: cycle.name,
            start_date: cycle.start_date.to_s,
            end_date: cycle.end_date.to_s,
          }

          spawn_plans
        end

        def finalize
          users = ::User.select { |user| user.receives?(:patch_cycle_planned) }.compact

          begin
            MailNotification[:patch_cycle_planned].deliver(users: users, cycle: cycle) unless users.blank?
          rescue => error
            Rails.logger.error(error)
          end
        end

        def schedule_next_cycle(execution_plan)
          cycle_plan.schedule_next_cycle
        end

        private

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(output[:cycle][:id])
        end

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

