module Actions
  module ForemanPatch
    module Cycle
      class Initiate < Actions::EntryAction

        def delay(delay_options, cycle, plan = nil)
          input.update serialize_args(cycle: cycle)
          add_missing_task_group(plan) if plan.present?

          super delay_options, cycle
        end

        def plan(cycle, plan = nil)
          input.update serialize_args(cycle: cycle)
          add_missing_task_group(plan) if plan.present?

          cycle.windows.each do |window|
            plan_action(Actions::ForemanPatch::Window::ResolveHosts, window)
          end
          plan_self
        end

        def run
          content_view_versions = cycle.hosts.map do |host|
            host.content_view.version(host.lifecycle_environment)
          end.uniq

          content_view_versions.each do |version|
            next unless available_content?(version)

            ::ForemanTasks.async_task(Actions::ForemanPatch::Cycle::PrepareContent, version, _('Updating content for patch cycle: %s') % cycle.name)
          end
        end

        def finalize
          cycle.windows.each(&:schedule)

          plan = find_plan
          plan.iterate if plan.present?
        end

        def humanized_name
          _('Initiating patch cycle: %s') % cycle.name
        end

        def cycle
          @cycle ||= ::ForemanPatch::Cycle.find(input[:cycle][:id])
        end

        private

        def available_content?(version)
          version.available_packages.any? or 
            version.available_errata.any? or
            ::Katello::Deb.in_repositories(version.library_repos).where.not(id: version.debs).any?
        end

        def add_missing_task_group(plan)
          if plan.task_group.nil?
            plan.task_group = ::ForemanPatch::PlanTaskGroup.create!
            plan.save!
          end
          task.add_missing_task_groups(plan.task_group)
        end

        def find_plan
          task.task_groups.find_by(type: 'ForemanPatch::PlanTaskGroup')&.plan
        end

      end
    end
  end
end
