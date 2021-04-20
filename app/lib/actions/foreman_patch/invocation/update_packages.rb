module Actions
  module ForemanPatch
    module Invocation
      class UpdatePackages < Actions::EntryAction
        include ::Actions::Helpers::WithDelegatedAction

        class UpdatePackagesFeature
          attr_reader :feature

          def initialize
            @feature = ::RemoteExecutionFeature.feature('katello_package_update')
          end

          def template
            feature.job_template
          end

          def effective_user
            if template.provider.supports_effective_user?
              Setting[:remote_execution_effective_user]
            else
              nil
            end
          end
        end

        def plan(host)
          action_subject(host)

          provider = feature.template.provider
          proxy_selector = provider.required_proxy_selector_for(feature.template) || ::RemoteExecutionProxySelector.new

          proxy = proxy_selector.determine_proxy(host, feature.template.provider_type.to_s)

          renderer = InputTemplateRenderer.new(feature.template, host)
          script = renderer.render
          raise _('Failed rendering template: %s') % renderer.error_message unless script

          plan_delegated_action(proxy, 
                                provider.proxy_action_class, 
                                provider.proxy_command_options(feature, host).merge({
                                  hostname: provider.find_ip_or_hostname(host),
                                  execution_timeout_interval: feature.template.execution_timeout_interval,
                                  script: script,
                                  secrets: provider.secrets(host),
                                }))
          plan_self
        end

        def run
          error! _('Package update failed') if exit_status != 0
        end

        def rescue_strategy
          ::Dynflow::Action::Rescue::Fail
        end

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

        def feature
          @feature ||= UpdatePackagesFeature.new
        end

        def exit_status
          delegated_output[:exit_status]
        end

      end
    end
  end
end
