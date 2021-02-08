module ForemanPatch
  class CyclePlan < ::ApplicationRecord
    UNITS = ['days', 'weeks', 'months'].freeze

    has_many :window_plans, class_name: 'ForemanPatch::WindowPlan', foreign_key: :cycle_plan_id, dependent: :nullify, inverse_of: :cycle_plan

    has_many :cycles, class_name: 'ForemanPatch::Cycle', foreign_key: :cycle_id, dependent: :nullify

    validates :name, presence: true, uniqueness: true
    validates :units, inclusion: {in: UNITS}, allow_blank: false

    scoped_search on: :name, complete_value: true
    scoped_search on: :units, complete_value: true
    scoped_search on: :interval, complete_value: true
  end
end

