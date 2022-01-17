module Actions
  module ForemanPatch
    module Cycle
      class Create < Actions::EntryAction

        def plan(params)
          input.update serialize_args(params)
          plan_self
        end

        def run
          cycle = ::ForemanPatch::Cycle.create!(params)

          output.update(cycle: cycle.to_action_input)
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
          {
            plan_id: input[:plan_id] || input[:plan][:id],
            name: input[:name],
            start_date: input[:start_date],
            end_date: input[:end_date],
          }
        end

      end
    end
  end
end

