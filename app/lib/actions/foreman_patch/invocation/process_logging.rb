module Actions
  module ForemanPatch
    module Invocation
      module ProcessLogging

        def invocation
          @invocation ||= ::ForemanPatch::Invocation.find_by(task_id: task.id)
        end

        def log_invocation_event(event, type = 'debug', timestamp = Time.zone.now)
          last = invocation.events.order(:sequence).last
          sequence = last ? last.sequence + 1 : 0
          invocation.events.create!(
            event_type: type,
            event: event,
            timestamp: timestamp,
            sequence: sequence
          )
        end

        def log_invocation_exception(exception)
          last = invocation.events.order(:sequence).last
          sequence = last ? last.sequence + 1 : 0
          invocation.events.create!(
            event_type: 'debug',
            event: "#{exception.class}: #{exception.message}",
            timestamp: Time.zone.now,
            sequence: sequence
          )
        end

        def with_invocation_error_logging
          unless catch(::Dynflow::Action::ERROR) { yield || true }
            log_invocation_exception(error.exception)
            throw ::Dynflow::Action::ERROR
          end
        rescue => e
          log_invocation_exception(e)
          raise e
        end
      end
    end
  end
end