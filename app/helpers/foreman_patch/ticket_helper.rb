module ForemanPatch
  module TicketHelper

    def ticket_url(window)
      return 'javascript:void(0)' if window.ticket_id.blank?

      path = Setting[:ticket_web_ui_path]
      path.gsub!(':id', window.ticket_id) unless window.ticket_id.blank?

      Setting[:ticket_api_host] + path
    end

    def ticket_link(window, options = {})
      url = ticket_url(window)
      
      if window.ticket_id.blank?
        body = options.delete(:body) || window.name
      else
        body = options.delete(:body) || window.ticket.fetch(Setting[:ticket_label_field], window.name)
      end

      link_to body, url, options
    end

  end
end
