module ForemanPatch
  module PatchingHelper

    def group_hosts_authorizer
      @group_hosts_authorizer ||= Authorizer.new(User.current, collection: @hosts)
    end

    def patch_invocation_status(invocation)
      task = invocation.task
      window_task = invocation.window_group.window.task

      return (window_task.result == 'cancelled' ? _('cancelled') : _('planned')) if task.nil?
      return task.state if task.state == 'running' || task.state == 'planned'
      return _('error') if task.result == 'warning'

      task.result
    end

    def patch_invocation_actions(task, host, group, invocation)
      links = []

      if authorized_for(main_app.hash_for_host_path(host).merge(auth_object: host, permission: :view_hosts, authorizer: group_hosts_authorizer))
        links << { title: _('Host Detail'),
                   action: { href: main_app.host_path(host), 'data-method': 'get', id: "#{host.name}-actions-detail" } }
      end

      if task.present? && authorized_for(main_app.hash_for_foreman_tasks_task_path(task).merge(auth_object: task, permission: :view_foreman_tasks))
        links << { title: _('Task Detail'),
                   action: { href: main_app.foreman_tasks_task_path(task),
                             'data-method': 'get',
                             id: "#{host.name}-actions-task" }
        }
      end

      links
    end

    def group_invocation_hosts(group, hosts)
      hosts.map do |host|
        invocation = group.invocations.find { |invocation| invocation.host_id == host.id }
        task = invocation.try(:task)

        {
          name: host.name,
          link: invocation_path(invocation),
          status: patch_invocation_status(invocation),
          actions: patch_invocation_actions(task, host, group, invocation)
        } 
      end
    end

    def group_task_buttons(task)
      buttons = []

      if authorized_for(permission: :view_foreman_tasks, auth_object: task, authorizer: Authorizer.new(User.current, collection: [task]))
        buttons << link_to(_('Task Details'), main_app.foreman_tasks_task_path(task),
                           class: 'btn btn-default',
                           title: _('See the task details'))
      end

      # if authorized
      buttons << link_to(_('Cancel'), main_app.cancel_foreman_tasks_task_path(task),
                         class: 'btn btn-danger',
                         title: _('Try to cancel the patching group'),
                         disabled: !task.cancellable?,
                         method: :post)
      buttons << link_to(_('Abort'), main_app.abort_foreman_tasks_task_path(task),
                         class: 'btn btn-danger',
                         title: _('Try to abort the patching group without waiting for its result'),
                         disabled: !task.cancellable?,
                         method: :post)
      # end

      buttons
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
