module Actions
  module ForemanPatch
    module Invocation
      class ProxyAction < ::Actions::ProxyAction
        include Actions::ForemanPatch::Invocation::ProcessLogging

        def on_data(data, meta = {})
          super
          process_proxy_data(output[:proxy_output])
        end

        def run(event = nil)
          with_invocation_error_logging { super }
        end

        private

        def get_proxy_data(response)
          data = super
          process_proxy_data(data)
          data
        end

        def process_proxy_data(data)
          events = data['result'].each_with_index.map do |update, idx|
            {
              sequence: update['sequence'] || idx,
              invocation_id: invocation.id,
              event: update['output'],
              timestamp: Time.at(update['timestamp']).getlocal,
              event_type: update['output_type'],
            }
          end
          if data['exit_status']
            last = events.last || { sequence: -1, timestamp: Time.zone.now }
            events << {
              sequence: last[:sequence] + 1,
              invocation_id: invocation.id,
              event: data['exit_status'],
              timestamp: last[:timestamp],
              event_type: 'exit',
            }
          end
          events.each_slice(1000) do |batch|
            ::ForemanPatch::Event.upsert_all(batch, unique_by: [:invocation_id, :sequence])
          end
        end

      end
    end
  end
end