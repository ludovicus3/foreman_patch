object @cycle_plan if @cycle_plan

attributes :id, :name, :description, :start_date, :active_count
node(:every) { |cp| { count: cp.interval, units: cp.units } }
