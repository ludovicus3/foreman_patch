module Actions
  module ForemanPatch
    module Round
      class Patch < Actions::ActionWithSubPlans
        include Dynflow::Action::WithBulkSubPlans

        middleware.use Actions::Middleware::WatchDelegatedProxySubTasks
        middleware.use Actions::Middleware::ProxyBatchTriggering

        def plan(round)
          action_subject(round)

          round.resolve_hosts!

          round.task_id = task.id
          round.save!

          limit_concurrency_level round.max_unavailable unless round.max_unavailable.nil?

          plan_self
        end

        def create_sub_plans
          current_batch.map do |invocation|
            trigger(Actions::ForemanPatch::Invocation::Patch, invocation)
          end
        end

        def rescue_strategy
          ::Dynflow::Action::Rescue::Skip
        end

        def run(event = nil)
          super unless event == Dynflow::Action::Skip
        end

        def initiate
          users = ::User.select { |user| user.receives?(:patch_group_initiated) }.compact

          begin
            MailNotification[:patch_group_initiated].deliver(users: users, group: round) unless users.blank?
          rescue => error
            Rails.logger.error(error)
          end

          super
        end

        def check_for_errors!
        end

        def on_finish
          users = ::User.select { |user| user.receives?(:patch_group_completed) }.compact

          MailNotification[:patch_group_completed].deliver(users: users, group: round) unless users.blank?
        rescue => error
          Rails.logger.error(error)
        end

        def round
          @round ||= ::ForemanPatch::Round.find(input[:round][:id])
        end

        def batch(from, size)
          round.invocations.offset(from).limit(size)
        end

        def total_count
          round.invocations.count
        end

        def humanized_name
          'Patch Group: %s' % round.name
        end

      end
    end
  end
end
