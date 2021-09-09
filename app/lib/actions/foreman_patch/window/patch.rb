module Actions
  module ForemanPatch
    module Window
      class Patch < Actions::EntryAction

        def delay(delay_options, window)
          window.task_id = task.id
          window.save!

          action_subject(window)

          super delay_options, window
        end

        def plan(window)
          window.task_id = task.id
          window.save!

          action_subject(window)

          sequence do
            window.window_groups.group_by(&:priority).each do |_, groups|
              concurrence do
                groups.each do |group|
                  plan_action(Actions::ForemanPatch::WindowGroup::Patch, group)
                end
              end
            end
          end
          plan_self
        end

        def window
          @window ||= ::ForemanPatch::Window.find(input[:window][:id])
        end

        def rescue_strategy_for_self
          ::Dynflow::Action::Rescue::Fail
        end

        def humanized_name
          if input and input[:window_name]
            _('Run Patch Window: %{window}' % {window: input[:window][:name]})
          else
            _('Run Patch Window')
          end
        end
      end
    end
  end
end
