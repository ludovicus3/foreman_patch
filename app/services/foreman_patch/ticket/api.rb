module ForemanPatch
  module Ticket
    module API
      attr_reader :request

      def host
        Setting[:ticket_api_host]
      end

      def proxy
        return nil if Setting[:ticket_api_proxy].blank?

        HttpProxy.friendly.find(Setting[:ticket_api_proxy])&.url
      end

      def get(path, params = {})
        send_request(:get, path, params)
      end

      def post(path, payload, params = {})
        send_request(:post, path, params, payload)
      end

      def put(path, payload, params = {})
        send_request(:put, path, params, payload)
      end

      def delete(path)
        send_request(:delete, path)
      end

      private 
      
      def send_request(method, path, params = {}, payload = nil)
        args = {
          method: method,
          url: URI.join(Setting[:ticket_api_host], path).to_s,
          headers: {
            accept: :json,
            content_type: :json,
            params: params,
          },
          user: Setting[:ticket_api_user],
          password: Setting[:ticket_api_password],
        }

        args[:payload] = payload.to_json unless payload.nil?
        args[:proxy] = proxy

        JSON.parse(RestClient::Request.execute(args))
      rescue RestClient::ExceptionWithResponse => error
        Rails.logger.error(error.response)
      rescue => error
        Rails.logger.error(error)
      end
    end
  end
end
