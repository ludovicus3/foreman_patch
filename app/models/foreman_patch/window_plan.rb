module ForemanPatch
  class WindowPlan < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    self.skip_time_zone_conversion_for_attributes = [:start_time]

    belongs_to :plan, class_name: 'ForemanPatch::Plan', inverse_of: :window_plans

    has_many :groups, class_name: 'ForemanPatch::Group', foreign_key: :default_window_plan_id

    validates :name, presence: true, uniqueness: { scope: :plan_id }
    validates :start_day, presence: true
    validates :start_time, presence: true

    scoped_search on: :name, complete_value: true
    scoped_search on: :plan_id, complete_value: true
    scoped_search on: :start_day, complete_value: true
    scoped_search on: :start_time, complete_value: true

    scoped_search relation: :plan, on: :name, complete_value: true

    def start_at(cycle)
      start_date = cycle.start_date + start_day.days

      Time.find_zone(Setting[:patch_schedule_time_zone]).local(
        start_date.year,
        start_date.month,
        start_date.day,
        start_time.hour,
        start_time.min,
        start_time.sec)
    end

    def end_by(cycle)
      start_at(cycle) + duration
    end

  end
end

