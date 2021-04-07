module ForemanPatch
  class WindowTaskGroup < ::ForemanTasks::TaskGroup
    has_one :window, foreign_key: :task_group_id, dependent: :nullify, class_name: 'ForemanPatch::Window'

    alias_method :resource, :window

    def resource_name
      N_('Window')
    end
  end
end
