module ForemanPatch
  class CyclePlanTaskGroup < ::ForemanTasks::TaskGroup
    has_one :cycle_plan, foreign_key: :task_group_id, dependent: :nullify, inverse_of: :task_group, class_name: 'ForemanPatch::CyclePlan'

    def resource_name
      N_('Cycle Plan')
    end
  end
end
