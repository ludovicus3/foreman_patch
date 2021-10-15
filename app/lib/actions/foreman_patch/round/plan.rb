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
          plan_action(::Actions::ForemanPatch::Round::ResolveHosts, action.output[:round])
        end

        private

        def params(group, window)
          {
            window: window,
            group: group.to_action_input,
            name: group.name,
            description: group.description,
            priority: group.priority,
            max_unavailable: group.max_unavailable,
          }
        end

      end
    end
  end
end
