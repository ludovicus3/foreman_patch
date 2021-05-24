module Actions
  module ForemanPatch
    module Invocation
      class EnsureServices < Actions::EntryAction
        include Actions::Helpers::WithFeatureAction

        def resource_locks
          :link
        end

        def plan(host)
          action_subject(host)

          sequence do
            plan_feature_action('ensure_services', host)
            plan_self
          end
        end

        def run
          if exit_status != 0
            users = ::User.select { |user| user.receives?(:patch_invocation_failure) }.compact

            begin
              MailNotification[:patch_invocation_failure].deliver(users: users, host: host, output: live_output) unless users.blank?
            rescue => error
              message = _('Unable to send patch invocation failure: %{error}') % {error: error}
              Rails.logger.error(message)
            end

            fail _('Ensure services failed')
          end
        end

        def finalize
          if exit_status == 0
            host.group_facet.last_patched_at = Time.current
            host.group_facet.save!
          end
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

