module Actions
  module ForemanPatch
    module Host
      class Reschedule < Actions::EntryAction

        def plan(host)
          input.update serialize_args(host: host)

          plan_self
        end

        def run
          host.invocations.planned.destroy_all

          ::ForemanPatch::Round.where(window: ::ForemanPatch::Window.planned, group: host.group).each do |round|
            round.invocations.find_or_create_by!(host_id: host.id)
          end
        end

        private

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

      end
    end
  end
end


