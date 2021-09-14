module ForemanPatch
  class Plan < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    UNITS = ['days', 'weeks', 'months', 'years'].freeze
    CORRECTIONS = ['weekday', 'last_day', 'last_weekday', 'avoid_weekend'].freeze

    has_many :window_plans, class_name: 'ForemanPatch::WindowPlan', foreign_key: :plan_id, dependent: :nullify, inverse_of: :plan

    has_many :cycles, -> { order(start_date: :desc) }, class_name: 'ForemanPatch::Cycle', foreign_key: :plan_id, dependent: :nullify

    belongs_to :task_group, class_name: 'ForemanPatch::PlanTaskGroup', inverse_of: :plan
    has_many :tasks, through: :task_group, class_name: 'ForemanTasks::Task'

    validates :name, presence: true, uniqueness: true
    validates :units, inclusion: {in: UNITS}, allow_blank: false
    validates :correction, inclusion: {in: CORRECTIONS}, allow_blank: true

    scoped_search on: :name, complete_value: true
    scoped_search on: :units, complete_value: true
    scoped_search on: :interval, complete_value: true
    scoped_search on: :start_date, complete_value: false

    before_destroy :stop

    def frequency
      interval.send(units)
    end

    def stopped?
      active_count == 0
    end

    def stop
      self.active_count = 0
      save!
      tasks.active.each(&:cancel)
    end

    def next_cycle_start
      next_date = start_date + frequency
      next_date = send(correction, next_date) unless correction.blank?
      next_date
    end

    def iterate
      return if stopped?

      count = active_count - cycles.active.count

      if count > 0
        ::ForemanTasks.async_task(::Actions::ForemanPatch::Cycle::Plan, self)
      else
        unless tasks.where(state: :scheduled).any?
          ::ForemanTasks.delay(::Actions::ForemanPatch::Cycle::Plan, delay_options, self)
        end
      end
    end

    private

    def weekday(next_date)
      offset = (next_date.day - 1) % 7
      shift = start_date.wday - (next_date.wday - offset)
      shift += 7 if shift < 0
      next_date.advance(days: shift - offset)
    end

    def last_day(next_date)
      next_date.end_of_month
    end

    def last_weekday(next_date)
      next_date = next_date.end_of_month
      ago = next_date.wday - start_date.wday
      ago += 7 unless ago >= 0
      next_date.advance(days: -ago)
    end

    def avoid_weekend(next_date)
      if next_date.saturday?
        (next_date.day == 1 ? next_date.advance(days: 2) : next_date.advance(days: -1))
      elsif next_date.sunday?
        (next_date.day == ::Time.days_in_month(next_date.month, next_date.year) ? next_date.advance(days: -2) : next_date.advance(days: 1))
      else
        next_date
      end
    end

    def delay_options
      Time.use_zone(Setting[:patch_schedule_time_zone]) do
        {
          start_at: cycles.active.last.end_date.beginning_of_day + 1.day
        }
      end
    end

  end
end

