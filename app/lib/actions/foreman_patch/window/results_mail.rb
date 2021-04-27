module Actions
  module ForemanPatch
    module Window
      class ResultsMail < Actions::EntryAction

        def plan(window)
          plan_self(:window => window.id)
        end

        def run
          ::User.current = ::User.anonymous_admin

          window = ::ForemanPatch::Window.find(input[:window])
          users = ::User.select { |user| user.receives?(:patch_window_results) }.compact

          begin
            MailNotification[:patch_window_results].deliver(users: users, window: window) unless (users.blank? || window.blank?)
          rescue => error
            message = _('Unable to send patch window results: %{error}' % {error: error})
            Rails.logger.error(message)
            output[:result] = message
          end
        end

        def finalize
          ::User.current = nil
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

      end
    end
  end
end

