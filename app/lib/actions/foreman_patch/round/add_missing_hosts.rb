module Actions
  module ForemanPatch
    module Round
      class AddMissingHosts < Actions::EntryAction

        def plan(round, *hosts)
          hosts.flatten!
          action_subject(round, hosts: hosts.map(&:to_action_input))

          round.group.hosts.where(id: hosts).each do |host|
            round.invocations.find_or_create_by!(host_id: host.id)
          end
        end

      end
    end
  end
end
