module ForemanPatch
  module WindowPatchingHelper

    def group_status(task, parent_task)
      return 'scheduled' if parent_task.nil?
      return (parent_task.result == 'cancelled' ? _('cancelled') : 'N/A') if task.nil?
      return task.state if task.state == 'running' || task.state == 'planned'

      task.result
    end

    def window_groups(window)
      window.window_groups.map do |group|
        {
          name: group.name,
          link: window_group_path(group),
          priority: group.priority,
          hostsCount: group.invocations.count,
          hostsLink: main_app.hosts_path(search: "patch_group_id = #{group.id}"),
          status: group_status(group.task, window.task),
          actions: []
        }
      end
    end

  end
end

