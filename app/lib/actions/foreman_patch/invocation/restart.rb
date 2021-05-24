module Actions
  module ForemanPatch
    module Invocation
      class Restart < Actions::EntryAction
        include Actions::Helpers::WithFeatureAction
        include Dynflow::Action::Polling

        def plan(host)
          action_subject(host)

          sequence do
            plan_feature_action('power_action', host, { 'action' => 'restart' })
            plan_self
          end
        end

        def done?
          external_task[:up]
        end

        def invoke_external_task
          if exit_status != 0
            send_failure_notification
            fail(_('Restart command failed to execute'))
          end

          sleep(60)
        
          schedule_timeout(Setting[:host_max_wait_for_up]) unless Setting[:host_max_wait_for_up]
          
          { up: false }
        end

        def poll_external_task
          begin
            socket = TCPSocket.new(host.ip, Setting[:remote_execution_ssh_port])
            socket.close

            { up: true }
          rescue => error
            Rails.logger.debug(error.message)
            { up: false }
          end
        end

        def process_timeout
          continuous_output.add_output(_('Server did not respond within alloted time after restart.'))

          send_failure_notification

          fail("Timeout exceeded.")
        end

        def send_failure_notification
          users = ::User.select { |user| user.receives?(:patch_invocation_failure) }.compact

          begin
            MailNotification[:patch_invocation_failure].deliver(user: users, host: host, output: live_output) unless users.blank?
          rescue => error
            message = _('Unable to send patch invocation failure: %{error}') % {error: error}
          end
        end

        def rescue_strategy
          ::Dynflow::Action::Rescue::Fail
        end

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

      end
    end
  end
end

