module ForemanPatch
  class Ticket

    attr_reader :window

    def self.save(window)
      ticket = Ticket.new(window)
      ticket.save
    end

    def self.load(window)
      ticket = Ticket.new(window)
      ticket.load
    end

    def initialize(window)
      @window = window
    end

    def save
      if window.ticket_id.blank?
        response = request(:post).execute
      else
        response = request(:put).execute
      end
      process_response(response) 
    rescue => error
      Rails.logger.error(error)
      {}
    end

    def load
      return {} if window.ticket_id.blank?

      process_response(request(:get).execute)
    rescue => error
      Rails.logger.error(error)
      {}
    end

    private

    def template
      @template ||= ReportTemplate.find(Setting[:ticket_template])
    end

    def payload
      template.render(variables: { window: window })
    end

    def url(method)
      path = Setting["ticket_api_#{method}_path"]
      path.gsub!(':id', window.ticket_id) unless window.ticket_id.blank?

      Setting[:ticket_api_host] + path
    end

    def proxy
      return nil if Setting[:ticket_api_proxy].blank?

      proxy = HttpProxy.friendly.find(Setting[:ticket_api_proxy])

      proxy&.url
    end

    def request(method)
      args = {
        method: method,
        url: url(method),
        headers: {
          accept: :json,
          content_type: :json,
          params: {},
        },
        user: Setting[:ticket_api_user],
        password: Setting[:ticket_api_password],
      }
      args[:payload] = payload unless [:get, :delete].include? method
      args[:proxy] = proxy

      RestClient::Request.new(args)
    end

    def process_response(response)
      hash = JSON.parse(response)

      hash['result']
    end

  end
end
