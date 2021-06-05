module ForemanPatch
  module CyclePlansHelper

    def plan_date_range(cycle_plan)
    end
      
    def planned_windows(cycle_plan, date)
      cycle.windows.select do |window|
        window.start_at.to_date === date
      end
    end

  end
end
