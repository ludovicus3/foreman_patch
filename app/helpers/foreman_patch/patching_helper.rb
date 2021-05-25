module ForemanPatch
  module PatchingHelper

    def patch_invocation_status(task, parent_task)
      return (parent_task.result == 'cancelled' ? _('cancelled') : 'N/A') if task.nil?
      return task.state if task.state == 'running' || task.state == 'planned'
      return _('error') if task.result == 'warning'

      task.result
    end

    def patch_invocation_actions(task, host, group, invocation)
      links = []

      links
    end

    def group_invocation_hosts(group, hosts)
      hosts.map do |host|
        invocation = group.invocations.find { |invocation| invocation.host_id == host.id }
        task = invocation.try(:task)

        {
          name: host.name,
          link: invocation_path(invocation),
          status: patch_invocation_status(task, group.task),
          actions: patch_invocation_actions(task, host, group, invocation)
        } 
      end
    end

  end
end
