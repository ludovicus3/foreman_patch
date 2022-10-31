module ForemanPatch
  class WindowPlan < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    attr_accessor :start_at, :end_by

    self.skip_time_zone_conversion_for_attributes = [:start_time]

    belongs_to :plan, class_name: 'ForemanPatch::Plan', inverse_of: :window_plans

    has_many :groups, class_name: 'ForemanPatch::Group', foreign_key: :default_window_plan_id

    validates :name, presence: true, uniqueness: { scope: :plan_id }
    validates :start_day, presence: true
    validates :start_time, presence: true
    validates :duration, presence: true

    scoped_search on: :name, complete_value: true
    scoped_search on: :plan_id, complete_value: true
    scoped_search on: :start_day, complete_value: true
    scoped_search on: :start_time, complete_value: true

    scoped_search relation: :plan, on: :name, complete_value: true

    after_initialize :init

    def start_time
      value = read_attribute(:start_time)
      return nil if value.blank?

      if value.acts_like?(:time)
        args = [value.year, value.month, value.day, value.hour, value.min, value.sec]
        time = Time.find_zone(Setting[:patch_schedule_time_zone]).local(*args)
      else
        time = Time.find_zone(Setting[:patch_schedule_time_zone]).parse(value)
      end
      time.to_time
    end

    def start_time=(value)
      if value.acts_like?(:time)
        time = value.in_time_zone(Setting[:patch_schedule_time_zone]).time
      else
        time = Time.find_zone(Setting[:patch_schedule_time_zone]).parse(value).time
      end
      write_attribute(:start_time, time)
    end

    def start_at
      start_date = plan.start_date + start_day.days
      start_time.change(year: start_date.year, month: start_date.month, day: start_date.day)
    end

    def end_by
      start_at + duration
    end

    def to_params
      {
        name: name,
        description: description,
        start_at: start_at,
        end_by: end_by,
      }
    end

    private

    def init
      self.start_day ||= 0
      self.start_time ||= Time.find_zone(Setting[:patch_schedule_time_zone]).parse('00:00:00')
      self.duration ||= 1.hour.to_i
    end

  end
end

