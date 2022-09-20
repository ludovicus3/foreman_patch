module Actions
  module ForemanPatch
    module Invocation
      class Patch < Actions::EntryAction
        execution_plan_hooks.use :update_status, on: ::Dynflow::ExecutionPlan.states

        def plan(invocation)
          action_subject(invocation.host, invocation_id: invocation.id)

          invocation.task_id = task.id
          invocation.save!

          sequence do
            plan_action(Actions::ForemanPatch::Invocation::UpdatePackages, host)
            plan_action(Actions::ForemanPatch::Invocation::Restart, host)
            plan_action(Actions::ForemanPatch::Invocation::EnsureServices, host)
          end
        end

        def humanized_name
          _("Patch %s") % host
        end

        def rescue_strategy
          planned_actions.each do |planned_action|
            if planned_action.steps.compact.any? { |step| step.state == :error }
              return rescue_strategy_for_planned_action(planned_action)
            end
          end
          rescue_strategy_for_self
        end

        def rescue_strategy_for_self
          ::Dynflow::Action::Rescue::Fail
        end

        def update_status(execution_plan)
          return unless root_action?

          case execution_plan.state
          when 'scheduled', 'pending', 'planning', 'planned'
            invocation.update!(status: 'pending')
          when 'running'
            invocation.update!(status: 'running')
          else
            invocation.update!(status: execution_plan.result)
          end
        end

        private

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

        def invocation
          @invocation ||= ::ForemanPatch::Invocation.find(input[:invocation_id])
        end

      end
    end
  end
end

