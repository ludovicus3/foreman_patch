module Actions
  module ForemanPatch
    module Cycle
      class Create < Actions::EntryAction

        def resource_locks
          :link
        end

        def plan(plan)
          action_subject(plan)

          cycle = ::ForemanPatch::Cycle.create!(plan.to_params)

          concurrence do
            plan.window_plans.each do |window_plan|
              plan_action(Actions::ForemanPatch::Window::Create, window_plan, cycle)
            end
          end

          plan.start_date = plan.next_cycle_start
          plan.save!

          plan_self(cycle: cycle.to_action_input)
        end

        def run
          output.update(cycle: cycle.to_action_input)

          users = ::User.select { |user| user.receives?(:patch_cycle_planned) }.compact

          begin
            MailNotification[:patch_cycle_planned].deliver(users: users, cycle: cycle) unless users.blank?
          rescue => error
            Rails.logger.error(error)
          end
        end

        def finalize
          plan = ::ForemanPatch::Plan.find(input[:plan][:id])

          ::ForemanTasks.delay(Actions::ForemanPatch::Cycle::Initiate, delay_options, cycle, plan)

          plan.iterate
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

        def humanized_name
          _('Create cycle:')
        end

        def humanized_input
        input.dig(:plan, :name)
        end

        private

        def delay_options
          Time.use_zone(Setting[:patch_schedule_time_zone]) do
            {
              start_at: cycle.start_date.beginning_of_day,
            }
          end
        end

      end
    end
  end
end

