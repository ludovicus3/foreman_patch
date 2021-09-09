module Actions
  module ForemanPatch
    module WindowGroup
      class ResolveHosts < Actions::EntryAction

        def plan(window_group, group)
          action_subject(group)

          plan_self(window_group: window_group)
        end

        def run
          group.hosts.each do |host|
            window_group.invocations.find_or_create_by!(host: host)
          end
        end

        private

        def window_group
          @window_group ||= ::ForemanPatch::WindowGroup.find(input[:window_group][:id])
        end

        def group
          @group ||= ::ForemanPatch::Group.find(input[:group][:id])
        end

      end
    end
  end
end
