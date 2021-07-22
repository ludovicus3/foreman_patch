module ForemanPatch
  class Cycle < ::ApplicationRecord

    belongs_to :cycle_plan, class_name: 'ForemanPatch::CyclePlan'

    has_many :windows, -> { order(start_at: :asc) }, class_name: 'ForemanPatch::Window', foreign_key: :cycle_id, inverse_of: :cycle
    has_many :tasks, through: :windows

    scoped_search on: :name, complete_value: true
    scoped_search on: :start_date, complete_value: false
    scoped_search on: :end_date, complete_value: false

    validates :name, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true

    before_validation :plan_cycle, if: :cycle_plan_id?
    after_create :plan_windows, if: :cycle_plan_id?

    def completed?
      end_date.past?
    end

    private

    def plan_cycle
      self.name = cycle_plan.name if name.nil?
      self.description = cycle_plan.description if description.nil?
      self.end_date = start_date + cycle_plan.frequency if end_date.nil?
    end

    def plan_windows
      cycle_plan.window_plans.each do |window_plan|
        windows.create(window_plan: window_plan)
      end
    end

  end
end

