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

    def invocation_task_buttons(task, invocation)
      buttons = []

      if authorized_for(permission: :view_foreman_tasks, auth_object: task)
        buttons << link_to(_('Task Details'), main_app.foreman_tasks_task_path(task),
                           class: 'btn btn-default',
                           title: _('See the task details'))
      end

      #if authorized_for... eventually
        buttons << link_to(_('Cancel Patch'), main_app.cancel_foreman_tasks_task_path(task),
                           class: 'btn btn-danger',
                           title: _('Try to cancel the patch of the host'),
                           disabled: !task.cancellable?,
                           method: :post)
        buttons << link_to(_('Abort Patch'), main_app.abort_foreman_tasks_task_path(task),
                           class: 'btn btn-danger',
                           title: _('Try to abort the patching of the host without waiting for its result'),
                           disabled: !task.cancellable?,
                           method: :post)
      #end
      buttons
    end

  end
end
