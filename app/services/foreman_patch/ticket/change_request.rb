module ForemanPatch
  module Ticket
    class ChangeRequest
      include API

      attr_reader :window, :response, :affected_items

      def self.publish(window)
        ticket = Ticket.new(window)
        ticket.save
      end

      def initialize(window)
        @window = window
        @hash = {}
        reload
      end

      def reload
        return if window.ticket_id.blank?

        @affected_items = AffectedItems.new(self)

        ticket
      end

      def save
        if window.ticket_id.blank?
          post(path, payload)
        else
          put(path, payload)
        end

        unless response.empty?
          @affected_items = AffectedItems.new(self)
          @affected_items.set(window.hosts)
        end

        window.update(ticket_id: id)

        ticket
      end

      def payload
        @payload ||= Payload.new(window)
      end

      def id
        ticket.fetch(Setting[:ticket_id_field], window.ticket_id)
      end

      def label
        ticket.fetch(Setting[:ticket_label_field], window.name)
      end

      def link
        return "#" if id.blank?

        Setting[:ticket_api_host] + Setting[:ticket_web_ui_path].gsub(':id', id)
      end

      def keys
        ticket.keys
      end

      def [](key)
        ticket[key]
      end

      class Jail < Safemode::Jail
        allow :[], :keys, :link, :label
      end

      private

      def ticket
        return {} if response.empty?

        response['result']
      end

      def path
        path = Setting[:ticket_api_path]
        path += "/#{window.ticket_id}" unless id.blank?
        path
      end

    end
  end
end
