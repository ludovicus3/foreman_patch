module ForemanPatch
  module Ticket
    class AffectedItems
      include API

      attr_reader :ticket

      def initialize(ticket)
        @ticket = ticket
      end

      def items
        @items ||= get_affected_items
      end

      def set(hosts)
        cmdb_items = get_configuration_items(hosts)

        add_affected_items(select_cmdb_items(cmdb_items))

        remove_affected_items(select_affected_items(cmdb_items, true))

        @items = get_affected_items
      end

      def add(hosts)
        add_affected_items(select_cmdb_items(get_configuration_items(hosts)))

        @items = get_affected_items
      end

      def remove(hosts)
        remove_affected_items(select_affected_items(get_configuration_items(hosts)))

        @items = get_affected_items
      end

      private

      def get_configuration_items(hosts)
        params = {
          sysparm_query: "host_nameIN#{hosts.map(&:name).join(',')}",
          sysparm_exclude_reference_link: true,
          sysparm_fields: 'sys_id,host_name',
        }

        get('/api/now/table/cmdb_ci_server', params)

        response.nil? ? [] : response['result']
      end

      def get_affected_items
        params = {
          sysparm_query: "task=#{ticket.id}",
          sysparm_exclude_reference_link: true,
          sysparm_fields: 'sys_id,task,ci_item',
        }

        get('/api/now/table/task_ci', params)

        response.nil? ? [] : response['result']
      end

      def select_cmdb_items(cmdb_items, inverse = false)
        affected_item_ids = get_affected_items.map { |i| i['cm_item'] }
        cmdb_items.select do |cmdb_item|
          inverse ^ (affected_item_ids.include? cmdb_item['sys_id'])
        end
      end

      def select_affected_items(cmdb_items, inverse = false)
        cmdb_item_ids = cmdb_items.map { |i| i['sys_id'] }
        items.select do |affected_item|
          inverse ^ (cmdb_item_ids.include? affected_item['ci_item'])
        end
      end

      def add_affected_items(cmdb_items)
        cmdb_items.each do |ci_item|
          add_affected_item(ci_item)
        end
      end

      def add_affected_item(cmdb_ci)
        params = {
          sysparm_exclude_reference_link: true,
          sysparm_fields: 'sys_id,task,ci_item',
        }

        payload = {
          ci_item: cmdb_ci['sys_id'],
          task: ticket.id,
        }

        post('/api/now/table/task_ci', payload, params)
      end

      def remove_affected_items(affected_items)
        affected_items.each do |affected_item|
          remove_affected_item(affected_item)
        end
      end

      def remove_affected_item(affected_item)
        delete("/api/now/table/task_ci/#{affected_item['sys_id']}")
      end

    end
  end
end
