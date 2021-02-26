module ForemanPatch
  class Window < ::ApplicationRecord
    before_create :execute_window_plan, if: :window_plan_id?

    belongs_to :window_plan, class_name: 'ForemanPatch::WindowPlan'

    belongs_to :cycle, class_name: 'ForemanPatch::Cycle', inverse_of: :windows

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    belongs_to :task_group, class_name: 'ForemanPatch::WindowTaskGroup'
    has_many :tasks, through: :task_group, class_name: 'ForemanTasks::Task'

    belongs_to :triggering, class_name: 'ForemanTasks::Triggering'

    has_many :window_groups, class_name: 'ForemanPatch::WindowGroups', inverse_of: :window
    has_many :groups, class_name: 'ForemanPatch::Group', through: :window_groups 

    validates :cycle, presence: true
    validates :name, presence: true, on: :update
    validates :start_at, presence: true, on: :update
    validates :end_by, presence: true, on: :update

    scoped_search on: :name, complete_value: true
    scoped_search on: :start_at, complete_value: false
    scoped_search on: :end_by, complete_value: false
    scoped_search on: :cycle_id, complete_value: false
    scoped_search relation: :cycle, on:  :name, complete_value: true, rename: 'cycle', only_explicit: true
    scoped_search on: :window_plan_id, complete_value: false
    scoped_search relation: :window_plan, on: :name, complete_value: true, rename: 'window_plan', only_explicit: true

    private

    def execute_window_plan
      self.tap do |window|
        window.name = window_plan.name if window.name.nil?
        window.description = window_plan.description if window.description.nil?
        window.start_at = (cycle.start_date + window_plan.start_day) + window_plan.start_time.seconds_since_midnight.seconds if window.start_at.nil?
        window.end_by = window.start_at + window_plan.duration if window.end_by.nil?

        window_plan.groups.each do |group|
          window.window_plans.build(group: group, priority: group.default_priority)
        end
      end
    end

  end
end

