module Actions
  module ForemanPatch
    module Window
      class ResolveHosts < Actions::EntryAction

        def plan(window)
          input.update serialize_args(window: window)

          sequence do
            concurrence do
              window.rounds.each do |round|
                plan_action(Actions::ForemanPatch::Round::ResolveHosts, round)
              end
            end

            plan_action(Actions::ForemanPatch::Window::Publish, window)
          end
        end

        def window
          @window ||= ::ForemanPatch::Window.find(input[:window][:id])
        end

        def humanized_name
          _('Resolve Hosts for:')
        end

        def humanized_input
          window.name
        end

      end
    end
  end
end
