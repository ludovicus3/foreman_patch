module ForemanPatch
  class Cycle < ::ApplicationRecord

    belongs_to :cycle_plan, class_name: 'ForemanPatch::CyclePlan'
    delegate :name, to: :cycle_plan

    has_many :windows, class_name: 'ForemanPatch::Window', foreign_key: :cycle_id, inverse_of: :cycle
    has_many :tasks, through: :windows

    scoped_search on: :name, complete_value: true
    scoped_search on: :start_date, complete_value: false

    after_create :create_windows_from_cycle_plan, if: :cycle_plan_id?

    private

    def create_windows_from_cycle_plan
      cycle_plan.window_plans.each do |window_plan|
        windows.create(window_plan: window_plan)
      end
    end

  end
end

