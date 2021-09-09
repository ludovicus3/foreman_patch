module ForemanPatch
  class Cycle < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :cycle_plan, class_name: 'ForemanPatch::CyclePlan'

    has_many :windows, -> { order(start_at: :asc) }, class_name: 'ForemanPatch::Window', foreign_key: :cycle_id, inverse_of: :cycle
    has_many :tasks, through: :windows
    has_many :hosts, through: :windows

    scoped_search on: :name, complete_value: true
    scoped_search on: :start_date, complete_value: false
    scoped_search on: :end_date, complete_value: false

    validates :name, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true

    scope :planned, -> { where('start_date > ?', Date.current) }
    scope :active, -> { where('end_date >= ?', Date.current) }
    scope :running, -> { where('? BETWEEN start_date AND end_date', Date.current) }
    scope :completed, -> { where('end_date < ?', Date.current) }

    def planned?
      start_date > Date.current
    end

    def active?
      end_date >= Date.current
    end

    def running?
      start_date <= Date.current and end_date >= Date.current
    end

    def completed?
      end_date < Date.current
    end

    class Jail < ::Safemode::Jail
      allow :id, :name, :description, :start_date, :end_date, :windows
    end

    def schedule
      ::ForemanTasks.delay(::Actions::ForemanPatch::Cycle::Initiate, delay_options, self)
    end

    private

    def delay_options
      Time.use_zone(Setting[:patch_schedule_time_zone]) do
        {
          start_at: start_date.beginning_of_day,
        }
      end
    end

  end
end

