module ForemanPatch
  module CyclesHelper

    def cycle_result(cycle, states)
      states = Array(states)

      cycle.windows.count do |window|
        states.include? window.state
      end
    end

    def cycle_length(cycle)
      if ForemanPatch::Cycle === cycle
        cycle = cycle.plan
      end

      cycle.interval.send(cycle.units).value / ActiveSupport::Duration::SECONDS_PER_DAY
    end

    def cycle_windows(cycle, date)
      cycle.windows.select do |window|
        window.start_at.to_date === date
      end
    end

  end
end
