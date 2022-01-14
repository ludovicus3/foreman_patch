module ForemanPatch
  module TicketHelper

    def ticket_link(window, options = {})
      body = options.delete(:body) || window.ticket.label

      link_to body, window.ticket.link, options
    end

  end
end
