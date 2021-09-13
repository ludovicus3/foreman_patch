module ForemanPatch
  class PlanTaskGroup < ::ForemanTasks::TaskGroup
    has_one :plan, foreign_key: :task_group_id, dependent: :nullify, inverse_of: :task_group, class_name: 'ForemanPatch::Plan'

    def resource_name
      N_('Plan')
    end
  end
end
