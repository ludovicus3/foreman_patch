module Actions
  module ForemanPatch
    module Cycle
      class Complete < Actions::EntryAction

        def delay(delay_options, cycle)
          action_subject(cycle)

          super delay_options, cycle
        end

        def plan(cycle)
          action_subject(cycle)
          
          plan_self
        end

        def finalize
          users = ::User.select { |user| user.receives?(:patch_cycle_completed) }.compact

          begin
            MailNotification[:patch_cycle_completed].deliver(users: users, cycle: cycle) unless users.blank?
          rescue => error
            Rails.logger.error(error)
          end
        end

        def humanized_name
          _('Complete Patch Cycle: %s') % input[:cycle][:name]
        end

        private

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

      end
    end
  end
end
