module ForemanPatch
  module Ticket
    module API
      attr_reader :response, :errors

      private

      def host
        Setting[:ticket_api_host]
      end

      def url(path)
        host + path
      end

      def proxy
        return nil if Setting[:ticket_api_proxy].blank?

        HttpProxy.friendly.find(Setting[:ticket_api_proxy])&.url
      end

      def get(path, params = {})
        request(:get, path, params)
      end

      def post(path, payload, params = {})
        request(:post, path, params, payload)
      end

      def put(path, payload, params = {})
        request(:put, path, params, payload)
      end

      def delete(path)
        request(:delete, path)
      end

      def request(method, path, params = {}, payload = nil)
        @response = nil

        args = {
          method: method,
          url: url(path),
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

        raw = RestClient::Request.execute(args)

        @response = JSON.parse(raw)
      rescue RestClient::ExceptionWithResponse => error
        @errors = JSON.parse(error.response)
        Rails.logger.error(error)
      rescue => error
        Rails.logger.error(error)
      end

    end
  end
end
