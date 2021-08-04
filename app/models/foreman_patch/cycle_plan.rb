module ForemanPatch
  class CyclePlan < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    UNITS = ['days', 'weeks', 'months'].freeze

    has_many :window_plans, class_name: 'ForemanPatch::WindowPlan', foreign_key: :cycle_plan_id, dependent: :nullify, inverse_of: :cycle_plan

    has_many :cycles, -> { order(start_date: :desc) }, class_name: 'ForemanPatch::Cycle', foreign_key: :cycle_plan_id, dependent: :nullify

    belongs_to :task_group, class_name: 'ForemanPatch::CyclePlanTaskGroup', inverse_of: :cycle_plan
    has_many :tasks, through: :task_group, class_name: 'ForemanTasks::Task'

    validates :name, presence: true, uniqueness: true
    validates :units, inclusion: {in: UNITS}, allow_blank: false

    scoped_search on: :name, complete_value: true
    scoped_search on: :units, complete_value: true
    scoped_search on: :interval, complete_value: true
    scoped_search on: :start_date, complete_value: false

    before_destroy :cancel

    def frequency
      interval.send(units)
    end

    def cancelled?
      return active_count == 0
    end

    def start
      self.active_count = 1
      save!
      schedule_next_cycle
    end

    def next_cycle_start
      if tasks.active.empty?
        next_date = start_date
        next_date += frequency until next_date > Date.current
        next_date.to_time
      else
        tasks.active.order(start_at: :desc).first.start_at + frequency
      end
    end

    def cancel
      self.active_count = 0
      save!
      tasks.active.each(&:cancel)
    end

    def schedule_next_cycle
      return if cancelled?

      ::ForemanTasks.delay(::Actions::ForemanPatch::CyclePlan::CreateCycle, delay_options, self)
    end

    private

    def delay_options
      {
        start_at: next_cycle_start,
      }
    end

  end
end

