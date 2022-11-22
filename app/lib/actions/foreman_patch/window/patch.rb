module Actions
  module ForemanPatch
    module Window
      class Patch < Actions::EntryAction
        execution_plan_hooks.use :update_window_status, on: ::Dynflow::ExecutionPlan.states

        def resource_locks
          :link
        end

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
            window.rounds.group_by(&:priority).each do |_, groups|
              concurrence do
                groups.each do |group|
                  plan_action(Actions::ForemanPatch::Round::Patch, group)
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
          if input and input[:window][:name]
            _('Run Patch Window: %{window}' % {window: input[:window][:name]})
          else
            _('Run Patch Window')
          end
        end

        def update_window_status(execution_plan)
          return unless root_action?

          case execution_plan.state
          when :scheduled
            window.status = 'scheduled'
          when :pending, :planning, :planned, :running
            window.status = 'running'
          when :stopped
            window.status = 'completed'
          else
            window.status = execution_plan.state
          end
          window.save!
        end
      end
    end
  end
end
