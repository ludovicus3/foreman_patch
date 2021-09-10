module Actions
  module ForemanPatch
    module Round
      class Create < Actions::EntryAction

        def plan(params)
          plan_self params
        end

        def run
          round = window.rounds.create!(params)

          output[:round] = round.to_action_input
        end

        private

        def params
          {
            name: input[:name],
            description: input[:description],
            priority: input[:priority],
            max_unavailable: input[:max_unavailable],
          }
        end

        def window
          @window ||= ::ForemanPatch::Window.find(input[:window][:id])
        end

      end
    end
  end
end

