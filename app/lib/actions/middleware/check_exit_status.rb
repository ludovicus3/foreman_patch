module Actions
  module Middleware
    class CheckExitStatus < Dynflow::Middleware

      def run(*args)
        pass(*args)

        if action.exit_status != 0
          send_failure_notification

          raise "Non-zero exit status"
        end
      end

      private

      def send_failure_notification
        users = ::Users.select { |user| user.receives?(:patch_invocation_failure) }.compact

        begin
          MailNotification[:patch_invocation_failure].deliver(users: users,
                                                              host: action.host,
                                                              output: action.live_output) unless users.blank?
        rescue => error
          message = _('Unable to send patch invocation failure: %{error}') % { error: error }
          Rails.logger.error(message)
        end
      end
    end
  end
end
