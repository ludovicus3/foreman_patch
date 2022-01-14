module Actions
  module ForemanPatch
    module Window
      class Publish < Actions::EntryAction

        def plan(window)
          input.update serialize_args(window: window)
          plan_self
        end

        def run
          ticket = ::ForemanPatch::Ticket.new(window)

          input.update(payload: ticket.payload.raw.compact)

          ticket.save

          output.update(response: ticket.response)
        end

        def window
          @window ||= ::ForemanPatch::Window.find(input[:window][:id])
        end

        def humanized_name
          _('Publish ticket for %s') % window.name
        end

      end
    end
  end
end
