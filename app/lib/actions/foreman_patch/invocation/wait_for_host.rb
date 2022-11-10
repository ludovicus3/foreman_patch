module Actions
  module ForemanPatch
    module Invocation
      class WaitForHost < Actions::EntryAction
        include Actions::Helpers::WithContinuousOutput
        include Actions::Helpers::FailureNotification
        include Dynflow::Action::Polling

        def plan(host)
          action_subject(host)

          plan_self
        end

        def done?
          external_task[:status] == 'available'
        end

        def invoke_external_task
          schedule_timeout(Setting[:host_max_wait_for_up]) if Setting[:host_max_wait_for_up]

          { status: 'waiting' }
        end

        def poll_external_task
          socket = TCPSocket.new(host.ip, Setting[:remote_execution_ssh_port])
          
          status = starting? ? 'available' : 'waiting'
          
          { status: status }
        rescue
          status = 'starting'

          { status: status }
        ensure
          socket.close if socket
          add_output("Poll result: #{status}")
        end

        def poll_intervals
          case external_task[:status]
          when 'waiting'
            [10, 1]
          when 'starting'
            [10]
          else
            super
          end
        end

        def on_finish
          add_output(_('Host is up'), 'stdout')
        end

        def process_timeout
          add_output(_('Server did not respond withing alloted time after restart.'), 'stderr')
          send_failure_notification
          fail('Timeout exceeded.')
        end

        def rescue_strategy
          ::Dynflow::Action::Rescue::Fail
        end

        def live_output
          continuous_output.sort!
          continuous_output.raw_outputs
        end

        def continuous_output_providers
          super << self
        end

        def fill_continuous_output(continuous_output)
          output.fetch('result', []).each do |raw_output|
            continuous_output.add_raw_output(raw_output)
          end
        end

        private

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

        def starting?
          external_task[:status] == 'starting'
        end

        def add_output(message, type = 'debug', timestamp = Time.now.getlocal)
          formatted_output = {
            output_type: type,
            output: message,
            timestamp: timestamp.to_f
          }

          output[:result] = [] if output[:result].nil?
          output[:result] << formatted_output
        end
      end
    end
  end
end
