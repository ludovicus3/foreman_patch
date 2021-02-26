module ForemanPatch
  class WindowPlan < ::ApplicationRecord
    belongs_to :cycle_plan, class_name: 'ForemanPatch::CyclePlan', inverse_of: :window_plans

    has_many :groups, class_name: 'ForemanPatch::Group', foreign_key: :default_window_plan_id

    validates :name, presence: true, uniqueness: { scope: :cycle_plan_id }
    validates :start_day, presence: true
    validates :start_time, presence: true

    scoped_search on: :name, complete_value: true
    scoped_search on: :cycle_plan_id, complete_value: true
    scoped_search on: :start_day, complete_value: true
    scoped_search on: :start_time, complete_value: true

    scoped_search relation: :cycle_plan, on: :name, complete_value: true
  end
end

