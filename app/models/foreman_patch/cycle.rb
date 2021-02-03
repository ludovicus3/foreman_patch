module ForemanPatch
  class Cycle < ::ApplicationRecord

    belongs_to :cycle_plan, class_name: 'ForemanPatch::CyclePlan'

    has_many :windows, class_name: 'ForemanPatch::Window', foreign_key: :cycle_id, inverse_of: :cycle
    has_many :tasks, through: :windows

  end
end

