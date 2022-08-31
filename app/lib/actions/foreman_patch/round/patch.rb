module Actions
  module ForemanPatch
    module Round
      class Patch < Actions::ActionWithSubPlans
        include Dynflow::Action::WithBulkSubPlans

        def plan(round)
          action_subject(round)

          limit_concurrency_level round.max_unavailable unless round.max_unavailable.nil?

          plan_self

          round.update!(status: 'pending')
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
          round.update!(status: 'running')

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
          round.update!(status: 'complete')

          users = ::User.select { |user| user.receives?(:patch_group_completed) }.compact

          MailNotification[:patch_group_completed].deliver(users: users, group: round) unless users.blank?
        rescue => error
          Rails.logger.error(error)
        end

        def round
          @round ||= ::ForemanPatch::Round.find(input[:round][:id])
        end

        def invocations
          round.invocations.order(:id)
        end

        def batch(from, size)
          invocations.offset(from).limit(size)
        end

        def total_count
          output[:total_count] || invocations.count
        end

        def humanized_name
          'Patch Group: %s' % round.name
        end

      end
    end
  end
end
