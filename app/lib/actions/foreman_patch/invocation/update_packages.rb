module Actions
  module ForemanPatch
    module Invocation
      class UpdatePackages < Actions::EntryAction
        include Actions::Helpers::WithFeatureAction

        def resource_locks
          :link
        end

        def plan(host)
          action_subject(host)

          sequence do
            plan_feature_action('katello_package_update', host, 
                                pre_script: 'yum clean all; subscription-manager refresh',
                                package: Setting[:skip_broken_patches] ? '--skip-broken' : nil)
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

            fail _('Package update failed')
          else
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

