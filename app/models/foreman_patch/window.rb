module ForemanPatch
  class Window < ::ApplicationRecord
    belongs_to :window_plan, class_name: 'ForemanPatch::WindowPlan'

    belongs_to :cycle, class_name: 'ForemanPatch::Cycle', inverse_of: :windows

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    belongs_to :task_group, class_name: 'ForemanPatch::WindowTaskGroup'
    has_many :tasks, through: :task_group, class_name: 'ForemanTasks::Task'

    belongs_to :triggering, class_name: 'ForemanTasks::Triggering'

    has_many :window_groups, class_name: 'ForemanPatch::WindowGroups', inverse_of: :window
    has_many :groups, class_name: 'ForemanPatch::Group', through: :window_groups 
  end
end

