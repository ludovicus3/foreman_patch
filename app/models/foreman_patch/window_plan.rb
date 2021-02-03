module ForemanPatch
  class WindowPlan < ::ApplicationRecord
    belongs_to :cycle_plan, class_name: 'ForemanPatch::CyclePlan', inverse_of: :window_plans

    has_many :groups, class_name: 'ForemanPatch::Groups', foreign_key: :default_window_id

    validates :name, presence: true, uniqueness: { scope: :cycle_plan_id }

    scoped_search on: :name, complete_value: true
  end
end

