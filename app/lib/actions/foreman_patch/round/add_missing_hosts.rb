module Actions
  module ForemanPatch
    module Round
      class AddMissingHosts < Actions::EntryAction

        def plan(round, hosts)
          action_subject(round, host_ids: hosts.map(&:id))

          round.group.hosts.where(id: hosts).each do |host|
            round.invocations.find_or_create_by!(host_id: host.id)
          end
        end

      end
    end
  end
end
