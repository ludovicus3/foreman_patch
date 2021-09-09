module Actions
  module ForemanPatch
    module Cycle
      class Create < Actions::EntryAction

        def plan(cycle_plan)
          action_subject(cycle_plan)

          plan_self

          cycle_plan.window_plans.each do |window_plan|
            concurrence do
              plan_action(::Actions::ForemanPatch::Window::Create, window_plan, output[:cycle])
            end
          end
        end

        def run
          cycle = ::ForemanPatch::Cycle.create!(params)

          output[:cycle] = cycle.to_action_input

          cycle_plan.start_date = cycle_plan.next_cycle_start
          cycle_plan.save!
        end

        def finalize
          cycle.schedule

          users = ::User.select { |user| user.receives?(:patch_cycle_planned) }.compact

          begin
            MailNotification[:patch_cycle_planned].deliver(users: users, cycle: cycle) unless users.blank?
          rescue => error
            Rails.logger.error(error)
          end
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(output[:cycle][:id])
        end

        private

        def params
          @params ||= {
            cycle_plan_id: cycle_plan.id,
            name: cycle_plan.name,
            description: cycle_plan.description,
            start_date: cycle_plan.start_date,
            end_date: cycle_plan.next_cycle_start - 1.day,
          }
        end

        def cycle_plan
          @cycle_plan ||= ::ForemanPatch::CyclePlan.find(input[:cycle_plan][:id])
        end

      end
    end
  end
end

