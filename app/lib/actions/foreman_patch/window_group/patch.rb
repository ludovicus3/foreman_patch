module Actions
  module ForemanPatch
    module WindowGroup
      class Patch < Actions::ActionWithSubPlans
        include Dynflow::Action::WithBulkSubPlans

        middleware.use Actions::Middleware::WatchDelegatedProxySubTasks
        middleware.use Actions::Middleware::ProxyBatchTriggering

        def plan(window_group)
          action_subject(window_group)

          window_group.task_id = task.id
          window_group.save!

          limit_concurrency_level window_group.max_unavailable unless window_group.max_unavailable.nil?
          plan_self
        end

        def create_sub_plans
          current_batch.map do |host|
            invocation = window_group.invocation_for_host(host)
            trigger(Actions::ForemanPatch::Invocation::Patch, invocation)
          end
        end

        def rescue_strategy
          ::Dynflow::Action::Rescue::Skip
        end

        def run(event = nil)
          super unless event == Dynflow::Action::Skip
        end

        def window_group
          @window_group ||= ::ForemanPatch::WindowGroup.find(input[:window_group][:id])
        end

        def batch(from, size)
          window_group.hosts.offset(from).limit(size)
        end

        def total_count
          window_group.hosts.count
        end

        def humanized_name
          'Patch Group: %s' % window_group.name
        end

      end
    end
  end
end
