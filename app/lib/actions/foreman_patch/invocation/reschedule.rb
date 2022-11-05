module Actions
  module ForemanPatch
    module Invocation
      class Reschedule < Actions::EntryAction

        def plan(invocation)
          action_subject(invocation)
          
          round = invocation.cycle.rounds.find_by(group: invocation.host.group)

          if round.nil?
            invocation.destroy
          else
            invocation.update!(round: round)
          end
        end

      end
    end
  end
end
