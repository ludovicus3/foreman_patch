module Actions
  module Helpers
    module WithFeatureAction
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

      def plan_feature_action(feature_name, host, **input_values)
        input['feature_name'] = feature_name

        invocation = TemplateInvocation.new(template, **input_values)

        provider = template.provider
        proxy_selector = provider.required_proxy_selector_for(template) || ::RemoteExecutionProxySelector.new

        proxy = proxy_selector.determine_proxy(host, template.provider_type.to_s)

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

        plan_delegated_action(proxy, provider.proxy_action_class, action_options)
      end

      def exit_status
        delegated_output[:exit_status]
      end

      def feature
        @feature ||= ::RemoteExecutionFeature.feature(input['feature_name'])
      end

      def template
        @template ||= feature.job_template
      end

      def live_output
        continuous_output.sort!
        continuous_output.raw_outputs
      end

      def continuous_output_providers
        super << self
      end

      def fill_continuous_output(continuous_output)
        delegated_output.fetch('result', []).each do |raw_output|
          continuous_output.add_raw_output(raw_output)
        end

        final_timestamp = (continuous_output.last_timestamp || task.ended_at).to_f + 1

        continuous_output.add_output(_('Exit status: %s') % exit_status, 'stdout', final_timestamp) if exit_status
      end

      def feature_action
        delegated_action
      end

    end
  end
end



