module ForemanPatch
  module PatchingHelper

    def round_hosts_authorizer
      @round_hosts_authorizer ||= Authorizer.new(User.current, collection: @hosts)
    end

    def patch_invocation_actions(round, invocation)
      host = invocation.host
      task = invocation.task

      links = []

      if authorized_for(main_app.hash_for_host_path(host).merge(auth_object: host, permission: :view_hosts, authorizer: round_hosts_authorizer))
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

      unless task.present?
        links << { title: _('Cancel'),
                   action: { href: invocation_path(invocation),
                             'data-method': 'delete',
                             id: "#{host.name}-actions-cancel" }
        }
      end

      if task.present? and task.pending?
        links << { title: _('Cancel'), 
                   action: { href: main_app.cancel_foreman_tasks_task_path(task),
                             'data-method': 'post',
                             id: "#{host.name}-actions-cancel" }
        }

        links << { title: _('Abort'),
                   action: { href: main_app.abort_foreman_tasks_task_path(task),
                             'data-method': 'post',
                             id: "#{host.name}-actions-abort" }
        }
      end

      links
    end

    def round_invocation_hosts(round)
      round.invocations.map do |invocation|
        {
          name: invocation.host.name,
          link: invocation_path(invocation),
          state: invocation.state,
          result: invocation.result,
          actions: patch_invocation_actions(round, invocation)
        } 
      end
    end

    def round_task_buttons(task)
      buttons = []

      if authorized_for(permission: :view_foreman_tasks, auth_object: task, authorizer: Authorizer.new(User.current, collection: [task]))
        buttons << link_to(_('Task Details'), main_app.foreman_tasks_task_path(task),
                           class: 'btn btn-default',
                           title: _('See the task details'))
      end

      # if authorized
      buttons << link_to(_('Cancel'), main_app.cancel_foreman_tasks_task_path(task),
                         class: 'btn btn-danger',
                         title: _('Try to cancel the patching round'),
                         disabled: !task.cancellable?,
                         method: :post)
      buttons << link_to(_('Abort'), main_app.abort_foreman_tasks_task_path(task),
                         class: 'btn btn-danger',
                         title: _('Try to abort the patching round without waiting for its result'),
                         disabled: !task.cancellable?,
                         method: :post)
      # end

      buttons
    end

    def invocation_task_buttons(task, invocation)
      buttons = []

      if task.present? && authorized_for(permission: :view_foreman_tasks, auth_object: task)
        buttons << link_to(_('Task Details'), main_app.foreman_tasks_task_path(task),
                           class: 'btn btn-default',
                           title: _('See the task details'))
      end

      #if authorized_for... eventually
      if task.present?
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
      end
      #end
      buttons
    end

  end
end
