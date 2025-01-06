module ForemanPatch
  module Ticket
    class ChangeRequest
      include API

      attr_reader :window, :response, :affected_items

      def initialize(window)
        @window = window
        @ticket = {}
        reload
      end

      def reload
        return if window.ticket_id.blank?

        response = get(path)
        unless response.empty?
          @ticket = response['result']
        
          @affected_items = AffectedItems.new(self)
        end

        @ticket
      end

      def save
        response = {}
        if window.ticket_id.blank?
          response = post(path, payload)
        else
          response = put(path, payload)
        end

        unless response.empty?
          @ticket = response['result']

          window.update(ticket_id: id) if id != window.ticket_id

          @affected_items = AffectedItems.new(self)
          @affected_items.set(window.hosts)
        end

        @ticket
      end

      def payload
        @payload ||= Payload.new(window)
      end

      def id
        @ticket.fetch(Setting[:ticket_id_field], window.ticket_id)
      end

      def label
        @ticket.fetch(Setting[:ticket_label_field], window.name)
      end

      def link
        return "#" if id.blank?

        Setting[:ticket_api_host] + Setting[:ticket_web_ui_path].gsub(':id', id)
      end

      def keys
        @ticket.keys
      end

      def [](key)
        @ticket[key]
      end

      def to_h
        @ticket
      end

      class Jail < Safemode::Jail
        allow :[], :keys, :link, :label
      end

      private

      def path
        path = Setting[:ticket_api_path]
        path += "/#{window.ticket_id}" unless id.blank?
        path
      end

    end
  end
end
