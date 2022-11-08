module Actions
  module ForemanPatch
    module Host
      class Reschedule < Actions::Base

        def plan(*hosts, **options)
          hosts = hosts.flatten
          input.update(**options, hosts: hosts.map(&:to_action_input))

          statuses = ['planned']
          statuses << 'scheduled' if options.fetch(:include_active, false)

          # this query must be converted to array otherwise changes will alter the results
          windows = ::ForemanPatch::Window.with_hosts(hosts).with_status(statuses).to_a

          sequence do
            ::ForemanPatch::Invocation.in_windows(windows).where(host: hosts).each do |invocation|
              plan_action(Actions::ForemanPatch::Invocation::Reschedule, invocation)
            end
            ::ForemanPatch::Round.in_windows(windows).missing_hosts(hosts).each do |round|
              plan_action(Actions::ForemanPatch::Round::AddMissingHosts, round, hosts)
            end

            plan_action(Actions::BulkAction, Actions::ForemanPatch::Window::Publish, windows) unless windows.empty?
          end
        end

      end
    end
  end
end

