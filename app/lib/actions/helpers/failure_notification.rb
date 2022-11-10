module Actions
  module Helpers
    module FailureNotification

      def send_failure_notification
        users = ::User.select { |user| user.receives?(:patch_invocation_failure) }.compact

        MailNotification[:patch_invocation_failure].deliver(
          users: users,
          host: host,
          output: live_output
        ) unless users.blank?
      rescue => error
        message = _('Unable to send patch invocation failure: %{error}') % {error: error}
        Rails.logger.error(message)
      end

    end
  end
end
