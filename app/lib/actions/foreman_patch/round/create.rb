module Actions
  module ForemanPatch
    module Round
      class Create < Actions::EntryAction

        def resource_locks
          :link
        end

        def plan(group, window)
          action_subject(group, window)

          round = window.rounds.create!({
            group: group,
            name: group.name,
            description: group.description,
            priority: group.priority,
            max_unavailable: group.max_unavailable,
          })

          plan_self(round: round.to_action_input)
          plan_action(Actions::ForemanPatch::Round::ResolveHosts, round)
        end

        def run
          output[:round] = round.to_action_input
        end

        def round
          @round = ::ForemanPatch::Round.find(input[:round][:id])
        end

      end
    end
  end
end

