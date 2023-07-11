module Actions
  module ForemanPatch
    module Invocation
      class Action < ::Actions::EntryAction
        include ::Actions::Helpers::WithDelegatedAction

        class TemplateInvocationInputValue
          attr_reader :template_invocation, :template_input, :value
          
          def initialize(invocation, input, value)
            @template_invocation = invocation
            @template_input = input
            @value = value
          end
        end

        class TemplateInvocation
          attr_reader :template, :input_values
          
          def initialize(template, **input_values)
            @template = template
            
            @input_values = template.template_inputs_with_foreign.map do |template_input|
              TemplateInvocationInputValue.new(self, template_input, input_values[template_input.name.intern])
            end
          end
          
          def effective_user
            if template.provider.supports_effective_user?
              Setting[:remote_execution_effective_user]
            else
              nil
            end
          end
        end

        def resource_locks
          :link
        end

        def plan(host, feature_name, required = true, **input_values)
          action_subject(host, feature_name: feature_name, required: required, **input_values)

          invocation = TemplateInvocation.new(template, **input_values)

          provider = template.provider
          proxy_selector = provider.required_proxy_selector_for(template) || ::RemoteExecutionProxySelector.new

          proxy = determine_proxy!(proxy_selector, template.provider_type.to_s, host)

          renderer = InputTemplateRenderer.new(template, host, invocation)
          script = renderer.render
          raise _('Failed rendering template: %s') % renderer.error_message unless script

          additional_options = {
            hostname: provider.find_ip_or_hostname(host),
            execution_timeout_interval: template.execution_timeout_interval,
            script: script,
            secrets: provider.secrets(host),
          }
          action_options = provider.proxy_command_options(invocation, host).merge(additional_options)

          sequence do
            plan_action(::Actions::ForemanPatch::Invocation::ProxyAction, proxy, provider.proxy_action_class, action_options)
            plan_self
          end
        end

        def run
          if exit_status != 0
            users = ::User.select { |user| user.receives?(:patch_invocation_failure) }.compact

            MailNotification[:patch_invocation_failure].deliver(users: users, host: host, output: live_output) unless users.blank?
            fail(_('Patch step failed: %{step}') % {step: humanized_name})
          end
        end
        
        def exit_status
          delegated_output[:exit_status]
        end

        def feature
          @feature ||= ::RemoteExecutionFeature.feature(input[:feature_name])
        end

        def template
          @template ||= feature.job_template
        end

        def required?
          input.fetch(:required, true)
        end

        def rescue_strategy_for_self
          required? ? ::Dynflow::Action::Rescue::Fail : ::Dynflow::Action::Rescue::Skip
        end

        private

        def host
          @host ||= ::Host.find(input[:host][:id])
        end

        def determine_proxy!(proxy_selector, provider, host)
          proxy = proxy_selector.determine_proxy(host, provider)
          if proxy == :not_available
            offline_proxies = proxy_selector.offline
            settings = { count: offline_proxies.count, proxy_names: offline_proxies.map(&:name).join(', ') }
            raise n_('The only applicable proxy %{proxy_names} is down',
                     'All %{count} applicable proxies are down. Tried %{proxy_names}',
                     offline_proxies.count) % settings
          elsif proxy == :not_defined
            settings = {
              global_proxy: 'remote_execution_global_proxy',
              fallback_proxy: 'remote_execution_fallback_proxy',
              provider: provider,
            }

            raise _('Could not use any proxy for the %{provider} job. Consider configuring %{global_proxy}, ' +
                    '%{fallback_proxy} in settings') % settings
          end
          proxy
        end

      end
    end
  end
end
          
