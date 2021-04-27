module Actions
  module ForemanPatch
    module Invocation
      class Restart < Actions::EntryAction
        include Actions::Helpers::WithFeatureAction

        def plan(host)
          action_subject(host)

          sequence do
            plan_feature_action('power_action', host, { 'action' => 'restart' })
            plan_self
          end
        end

        def run(event = nil)
        end

        def rescue_strategy
          ::Dynflow::Action::Rescue::Fail
        end

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

      end
    end
  end
end

