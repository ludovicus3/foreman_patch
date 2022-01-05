module Actions
  module ForemanPatch
    module Window
      class Create < Actions::Base

        def plan(params)
          plan_self params
        end

        def run
          window = cycle.windows.create!(params)

          output.update(window: window.to_action_input)
        end

        private

        def params
          {
            name: input[:name],
            description: input[:description],
            start_at: input[:start_at],
            end_by: input[:end_by],
          }
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

      end
    end
  end
end
