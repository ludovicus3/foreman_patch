module Actions
  module ForemanPatch
    module Invocation
      class WaitForHost < Actions::EntryAction
        include Dynflow::Action::Polling
        include ::Actions::ForemanPatch::Invocation::ProcessLogging

        def plan(host)
          action_subject(host)

          plan_self
        end

        def done?
          ['available', 'timeout'].include? external_task
        end

        def invoke_external_task
          schedule_timeout(Setting[:host_max_wait_for_up]) if Setting[:host_max_wait_for_up]

          'waiting'
        end

        def poll_external_task
          return status = external_task if external_task == 'timeout'

          socket = TCPSocket.new(host.ip, Setting[:remote_execution_ssh_port])
          
          status = starting? ? 'available' : 'waiting'
        rescue
          status = 'starting'
        ensure
          socket.close if socket
          log_invocation_event("Poll result: #{status}")
        end

        def poll_intervals
          case external_task
          when 'waiting'
            [1]
          when 'starting'
            [10]
          else
            super
          end
        end

        def on_finish
          log_invocation_event(_('Host is up'), 'stdout') if external_task == 'available'
        end

        def process_timeout
          log_invocation_event(_('Server did not respond withing alloted time after restart.'), 'stderr')

          self.external_task = 'timeout'
        end

        private

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

        def starting?
          external_task == 'starting'
        end

      end
    end
  end
end
