module Actions
  module ForemanPatch
    module Window
      class Publish < Actions::EntryAction

        def resource_links
          :link
        end

        def plan(window)
          action_subject(window)

          plan_self
        end

        def run
          ticket = ::ForemanPatch::Ticket.save(window)

          window.ticket_id = ticket.fetch(Setting[:ticket_id_field], window.ticket_id)
          window.save!

          output.update(ticket: ticket)
        end

        def humanized_name
          'Publish %s ticket' % window.name
        end

        private

        def window
          @window ||= ::ForemanPatch::Window.find(input[:window][:id])
        end

      end
    end
  end
end
