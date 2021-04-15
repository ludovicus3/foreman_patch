module Actions
  module ForemanPatch
    module Invocation
      class Patch < Actions::EntryAction
        def plan(invocation)
          action_subject(host, invocation_id: invocation.id)

          invocation.task_id = task.id
          invocation.save!

          sequence do
            plan_action(Actions::ForemanPatch::Invocation::UpdatePackages, host)
            plan_action(Actions::ForemanPatch::Invocation::Restart, host)
            plan_self
          end
        end

        def humanized_name
          _("Patch %s") % host
        end

        def rescue_strategy
          ::Dynflow::Action::Rescue::Fail
        end

        def host
          @host ||= input[:host][:id]
        end

        def invocation
          @invocation ||= input[:invocation_id]
        end

      end
    end
  end
end

