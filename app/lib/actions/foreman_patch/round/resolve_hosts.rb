module Actions
  module ForemanPatch
    module Round
      class ResolveHosts < Actions::EntryAction

        def plan(round, hosts)
          plan_self(round: round, hosts: hosts)
        end

        def run
          output[:invocations] = []
          input[:hosts].each do |host|
            output[:invocations] << round.invocations.find_or_create_by!(host_id: host[:id])
          end
        end

        private

        def round
          @round ||= ::ForemanPatch::Round.find(input[:round][:id])
        end

      end
    end
  end
end
