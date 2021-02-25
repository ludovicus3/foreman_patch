object @window_plan if @window_plan

extends 'foreman_patch/api/window_plans/base'

child cycle_plan: :cycle_plan do
  attributes :id, :name
end

attributes :created_at, :updated_at

