module Actions
  module ForemanPatch
    module Round
      class ResolveHosts < Actions::EntryAction

        def plan(round)
          round = round.to_action_input if ::ForemanPatch::Round === round

          plan_self(round: round)
        end

        def run
          output[:invocations] = {
            added: add_missing_hosts,
            removed: remove_non_group_hosts,
          }
        end

        private

        def add_missing_hosts
          return [] if round.group.nil?

          round.group.hosts.map do |host|
            round.invocations.find_or_create_by!(host_id: host.id).to_action_input
          end
        end

        def remove_non_group_hosts
          return [] if round.group.nil?

          invocations = round.invocations.where.not(host_id: round.group.host_ids).destroy_all

          invocations.map do |invocation|
            invocation.to_action_input
          end
        end

        def round
          @round ||= ::ForemanPatch::Round.find(input[:round][:id])
        end

      end
    end
  end
end
