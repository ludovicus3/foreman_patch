module Actions
  module ForemanPatch
    module Invocation
      class WaitForHost < Actions::EntryAction
        include Actions::Helpers::WithContinuousOutput
        include Dynflow::Action::Polling

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
          status = host.facts['last_boot'] > task.started_at ? 'available' : 'waiting'
          add_output("Poll result: #{status}")
          status
        end

        def poll_interval
          30 # seconds
        end

        def on_finish
          add_output(_('Host is up'), 'stdout') if external_task == 'available'
        end

        def process_timeout
          add_output(_('Server did not respond withing alloted time after restart.'), 'stderr')

          self.external_task = 'timeout'
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
