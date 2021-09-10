module Actions
  module ForemanPatch
    module Round
      class Plan < Actions::EntryAction

        def resource_locks
          :link
        end

        def plan(group, window)
          action_subject(group, window: window)

          action = plan_action(::Actions::ForemanPatch::Round::Create, params(group, window))
          plan_action(::Actions::ForemanPatch::Round::ResolveHosts, action.output[:round], hosts)
        end

        private

        def params(group, window)
          {
            window: window,
            name: group.name,
            description: group.description,
            priority: group.priority,
            max_unavailable: group.max_unavailable,
          }
        end

        def hosts
          group.hosts.map do |host|
            host.to_action_input
          end
        end

      end
    end
  end
end
