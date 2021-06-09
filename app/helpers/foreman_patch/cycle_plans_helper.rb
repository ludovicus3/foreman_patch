module ForemanPatch
  module CyclePlansHelper

    def plan_windows(cycle_plan, day)
      day = (day - cycle_plan.next_cycle).to_i

      cycle_plan.window_plans.select do |window|
        window.start_day == day
      end
    end

  end
end
