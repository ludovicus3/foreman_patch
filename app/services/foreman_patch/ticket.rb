module ForemanPatch
  class Ticket

    attr_reader :window, :response

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
      @response = nil
      @hash = {}
    end

    def save
      if window.ticket_id.blank?
        @response = request(:post).execute
      else
        @response = request(:put).execute
      end
      process_response

    rescue => error
      process_error(error)
      @hash
    end

    def load
      return {} if window.ticket_id.blank?

      @response = request(:get).execute
      process_response

      @hash
    rescue => error
      process_error(error)
      @hash
    end

    def payload
      @payload ||= TicketPayload.new(window)
    end

    def id
      hash.fetch(Setting[:ticket_id_field], window.ticket_id)
    end

    def label
      hash.fetch(Setting[:ticket_label_field], window.name)
    end

    def link
      return "#" if window.ticket_id.blank?

      Setting[:ticket_api_host] + Setting[:ticket_web_ui_path].gsub(':id', window.ticket_id)
    end

    def keys
      hash.keys
    end

    def [](key)
      hash[key]
    end

    class Jail < Safemode::Jail
      allow :[], :keys, :link, :label
    end

    private

    def hash
      load if response.nil?
      @hash
    end

    def url
      path = Setting[:ticket_api_path]
      path += "/#{window.ticket_id}" unless window.ticket_id.blank?

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
        url: url,
        headers: {
          accept: :json,
          content_type: :json,
          params: {},
        },
        user: Setting[:ticket_api_user],
        password: Setting[:ticket_api_password],
      }
      args[:payload] = payload.to_json unless [:get, :delete].include? method
      args[:proxy] = proxy

      RestClient::Request.new(args)
    end

    def process_response
      Rails.logger.debug response.description

      @hash.update(JSON.parse(response)['result'])

      window.update(ticket_id: id)
    rescue => error
      process_error(error)
    end

    def process_error(error)
      Rails.logger.error(error)
    end

  end
end
