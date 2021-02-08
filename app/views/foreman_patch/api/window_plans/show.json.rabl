object @window_plan if @window_plan

attributes :id, :name, :description, :start_day, :start_time, :cycle_plan_id

child cycle_plan: :cycle_plan do
  attributes :id, :name
end
