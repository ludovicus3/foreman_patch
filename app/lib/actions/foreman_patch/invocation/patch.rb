module Actions
  module ForemanPatch
    module Invocation
      class Patch < Actions::EntryAction
        include ::Actions::Helpers::WithContinuousOutput
        include ::Actions::ForemanPatch::Invocation::ProcessLogging

        execution_plan_hooks.use :update_status, on: ::Dynflow::ExecutionPlan.states

        def plan(invocation)
          action_subject(invocation.host, invocation_id: invocation.id)

          invocation.update!(task_id: task.id)

          sequence do
            plan_action(Actions::ForemanPatch::Invocation::Action, host, 'katello_package_update',
                        pre_script: 'yum clean all; subscription-manager refresh',
                        package: Setting[:skip_broken_patches] ? '--skip-broken' : nil)
            plan_action(Actions::ForemanPatch::Invocation::Action, host, 'power_action',
                        action: 'restart')
            plan_action(Actions::ForemanPatch::Invocation::WaitForHost, host)
            plan_action(Actions::ForemanPatch::Invocation::Action, host, 'ensure_services', false)
            plan_self
          end
        end

        def finalize
          host.group_facet.last_patched_at = Time.current
          host.group_facet.save!
        end

        def update_status(execution_plan)
          return unless root_action?

          case execution_plan.state
          when :scheduled, :pending, :planning, :planned
            invocation.update!(status: 'pending')
          when :running
            invocation.update!(status: 'running')
          else
            action = failed_action
            if action.nil?
              invocation.update!(status: 'success')
            else
              invocation.update!(status: action.required? ? 'error' : 'warning')
            end
          end
        end

        def live_output
          continuous_output.sort!
          continuous_output.raw_outputs
        end

        def continuous_output_providers
          super << self
        end

        def fill_continuous_output(continuous_output)
          invocation.events.order(:sequence).find_each do |output|
            if output.event_type == 'exit'
              continuous_output.add_output(_('Exit status: %s') % output.event, 'stdout', output.timestamp)
            else
              continuous_output.add_raw_output(output.as_raw_continuous_output)
            end
          end
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

        def humanized_name
          _('Patch:')
        end

        def humanized_input
          host.name
        end

        private

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

        def failed_action
          planned_actions.find do |action|
            action.steps.compact.any? { |step| [:error, :skipped].include? step.state }
          end
        end

      end
    end
  end
end
          
