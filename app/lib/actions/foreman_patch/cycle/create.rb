module Actions
  module ForemanPatch
    module Cycle
      class Create < Actions::Base

        def plan(params)
          plan_self params

          cycle_plan.window_plans.each do |window_plan|
            concurrence do
              plan_action(::Actions::ForemanPatch::Window::Create, window_plan, output[:cycle])
            end
          end
        end

        def run
          cycle = ::ForemanPatch::Cycle.create!(params)

          output[:cycle] = cycle.to_action_input
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
            cycle_plan_id: input[:cycle_plan][:id],
            name: input[:name],
            description: input[:description],
            start_date: input[:start_date],
            end_date: input[:end_date],
          }
        end

        def cycle_plan
          @cycle_plan ||= ::ForemanPatch::CyclePlan.find(input[:cycle_plan][:id])
        end

      end
    end
  end
end

